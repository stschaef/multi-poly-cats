{-# OPTIONS --safe #-}
module Cubical.Categories.Monad.Kleisli where

open import Cubical.Foundations.Prelude
open import Cubical.Categories.Category
open import Cubical.Categories.Functor
open import Cubical.Categories.NaturalTransformation
open import Cubical.Categories.Monad.Base

open import Cubical.Tactics.CategorySolver.Reflection
open import Cubical.Tactics.FunctorSolver.Reflection

private
  variable
    ℓ ℓ' : Level

open Category
open Functor
open NatTrans

module _ {C : Category ℓ ℓ'} (T : Monad C) where
  open IsMonad (T .snd)
  private
    variable
      a b c : C .ob
      k k' : C [ a , b ]
  Kleisli : Category _ _
  Kleisli .ob = C .ob
  Kleisli .Hom[_,_] x y = C [ x , T .fst ⟅ y ⟆ ]
  Kleisli .id = η ⟦ _ ⟧
  Kleisli ._⋆_ f g = (bind ⟦ _ ⟧) g ∘⟨ C ⟩ f
  Kleisli .⋆IdL f = sym (C .⋆Assoc _ _ _) ∙ cong₂ (comp' C) refl (sym (η .N-hom _))
                    ∙ C .⋆Assoc _ _ _ ∙ cong₂ (seq' C) refl (λ i → idl-μ i ⟦ _ ⟧ ) ∙ ⋆IdR C _
  Kleisli .⋆IdR f = cong₂ (seq' C) refl (λ i → idr-μ i ⟦ _ ⟧) ∙ ⋆IdR C _
  Kleisli .⋆Assoc f g h =  (⋆Assoc C _ _ _) ∙ cong₂ (seq' C) refl
    -- T g ⋆ μ ⋆ T h ⋆ μ
    (lem0 ∙ cong₂ (seq' C) (cong₂ (seq' C) refl (sym (μ .N-hom _))) refl
    -- T g ⋆ T (T h) ⋆ μ ⋆ μ
    ∙ lem1 ∙ cong₂ (seq' C) refl ((λ i → assoc-μ (~ i) ⟦ _ ⟧))
    ∙ lem2
    )
    where
      lem0 : C ._⋆_ ((C ⋆ F-hom (T .fst) g) (N-ob μ _)) ((C ⋆ k) (N-ob μ _))
           ≡ T .fst ⟪ g ⟫ ⋆⟨ C ⟩ (μ ⟦ _ ⟧ ⋆⟨ C ⟩ k) ⋆⟨ C ⟩ μ ⟦ _ ⟧ -- (T .fst ⟪ g ⟫) ⋆⟨ C ⟩ T .fst ⟪ μ ⟦ _ ⟧ ⋆⟨ C ⟩ k ⟫ ⋆⟨ C ⟩ μ ⟦ _ ⟧
      lem0 = solveFunctorDebug! C C (T .fst)

      lem1 : (C ⋆ (C ⋆ F-hom (T .fst) g) ((C ⋆ F-hom (T .fst) (F-hom (T .fst) h)) (T .snd .IsMonad.μ .N-ob (F-ob (T .fst) _)))) (N-ob (T .snd .IsMonad.μ) _)
        ≡ (T .fst ⟪ g ⟫ ⋆⟨ C ⟩ T .fst ⟪ T .fst ⟪ h ⟫ ⟫) ⋆⟨ C ⟩ (μ ⟦ _ ⟧ ⋆⟨ C ⟩ μ ⟦ _ ⟧)
      lem1 = solveFunctor! C C (T .fst)

      lem2 : (C ⋆ (C ⋆ F-hom (T .fst) g) (F-hom (T .fst) (F-hom (T .fst) h))) ((C ⋆ F-hom (T .fst) (N-ob (T .snd .IsMonad.μ) _)) (T .snd .IsMonad.μ .N-ob _)) ≡ (C ⋆ F-hom (T .fst) ((C ⋆ g) ((C ⋆ F-hom (T .fst) h) (N-ob μ _)))) (N-ob μ _)
      lem2 = solveFunctor! C C (T .fst)
  Kleisli .isSetHom = isSetHom C
