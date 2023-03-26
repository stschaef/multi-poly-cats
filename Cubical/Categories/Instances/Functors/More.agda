{-# OPTIONS --safe #-}

module Cubical.Categories.Instances.Functors.More where

open import Cubical.Categories.Category renaming (isIso to isIsoC)
open import Cubical.Categories.Functor.Base
open import Cubical.Categories.NaturalTransformation.Base
open import Cubical.Categories.NaturalTransformation.Properties
open import Cubical.Categories.Morphism
open import Cubical.Foundations.Prelude hiding (≡⟨⟩-syntax; _≡⟨_⟩_)
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Equiv.Properties
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Categories.Instances.Functors
open import Cubical.Categories.Constructions.BinProduct

open import AltEquationalReasoning
open import Cubical.Tactics.CategorySolver.Reflection

private
  variable
    ℓC ℓC' ℓD ℓD' ℓΓ ℓΓ' : Level

module _ (C : Category ℓC ℓC') (D : Category ℓD ℓD') where
  open Category
  open Functor
  open NatTrans

  appF : Functor ((FUNCTOR C D) ×C C) D
  appF .F-ob (F , c) = F ⟅ c ⟆
  appF .F-hom {x = (F , c)}{y = (F' , c')} (α , f) = F ⟪ f ⟫ ⋆⟨ D ⟩ α .N-ob c'
  appF .F-id {x = (F , c)}=
    (F ⟪ C .id ⟫ ⋆⟨ D ⟩ D .id) ≡⟨ (λ i → F .F-id i ⋆⟨ D ⟩ D .id) ⟩
    (D .id ⋆⟨ D ⟩ D .id) ≡⟨ D .⋆IdR (D .id) ⟩
    (D .id) ∎
  appF .F-seq {x = (F , c)}{y = (F' , c')}{z = (F'' , c'')}(α , f) (α' , f') =
    F ⟪ f ⋆⟨ C ⟩ f' ⟫ ⋆⟨ D ⟩ (α .N-ob _ ⋆⟨ D ⟩ α' .N-ob c'')
      ≡⟨ (λ i → F .F-seq f f' i ⋆⟨ D ⟩ (α .N-ob _ ⋆⟨ D ⟩ α' .N-ob c'')) ⟩
    F ⟪ f ⟫ ⋆⟨ D ⟩ F ⟪ f' ⟫ ⋆⟨ D ⟩ (α .N-ob _ ⋆⟨ D ⟩ α' .N-ob c'')
      ≡⟨ solveCat! D ⟩
    F ⟪ f ⟫ ⋆⟨ D ⟩ ((F ⟪ f' ⟫ ⋆⟨ D ⟩ α .N-ob _) ⋆⟨ D ⟩ α' .N-ob c'')
      ≡⟨ (λ i → F ⟪ f ⟫ ⋆⟨ D ⟩ (α .N-hom f' i ⋆⟨ D ⟩ α' .N-ob c'')) ⟩
    F ⟪ f ⟫ ⋆⟨ D ⟩ ((α .N-ob _ ⋆⟨ D ⟩ F' ⟪ f' ⟫) ⋆⟨ D ⟩ α' .N-ob c'')
      ≡⟨ solveCat! D ⟩
    (F ⟪ f ⟫ ⋆⟨ D ⟩ α .N-ob c') ⋆⟨ D ⟩ (F' ⟪ f' ⟫ ⋆⟨ D ⟩ α' .N-ob c'') ∎

  module _ {Γ : Category ℓΓ ℓΓ'} where
    λF : Functor (Γ ×C C) D → Functor Γ (FUNCTOR C D)
    λF F .F-ob a .F-ob b = F ⟅ a , b ⟆
    λF F .F-ob a .F-hom f = F .F-hom (Γ .id , f)
    λF F .F-ob a .F-id = F .F-id
    λF F .F-ob a .F-seq f g =
      F .F-hom (Γ .id , f ⋆⟨ C ⟩ g)
        ≡⟨ (λ i → F .F-hom ((Γ .⋆IdL (Γ .id) (~ i)) , f ⋆⟨ C ⟩ g)) ⟩
      F .F-hom (Γ .id ⋆⟨ Γ ⟩ Γ .id , f ⋆⟨ C ⟩ g)
        ≡⟨ F .F-seq (Γ .id , f) (Γ .id , g) ⟩
      F .F-hom (Γ .id , f) ⋆⟨ D ⟩ F .F-hom (Γ .id , g ) ∎
    λF F .F-hom γ .N-ob b = F .F-hom (γ , C .id)
    λF F .F-hom γ .N-hom f =
      F .F-hom (Γ .id , f) ⋆⟨ D ⟩ F .F-hom (γ , C .id)
        ≡⟨ sym (F .F-seq (Γ .id , f) (γ , C .id)) ⟩
      F .F-hom (Γ .id ⋆⟨ Γ ⟩ γ , f ⋆⟨ C ⟩ C .id)
        ≡⟨ (λ i → F .F-hom ((idTrans (Id {C = Γ}) .N-hom γ (~ i)) , idTrans (Id {C = C}) .N-hom f i)) ⟩
      F .F-hom (γ ⋆⟨ Γ ⟩ Γ .id , C .id ⋆⟨ C ⟩ f)
        ≡⟨ F .F-seq (γ , C .id) (Γ .id , f) ⟩
      F .F-hom (γ , C .id) ⋆⟨ D ⟩ F .F-hom (Γ .id , f)  ∎
    λF F .F-id = makeNatTransPath (funExt (λ a → F .F-id))
    λF F .F-seq γ δ = makeNatTransPath (funExt (λ a →
        F .F-hom (γ ⋆⟨ Γ ⟩ δ , C .id)
          ≡⟨ (λ i → F .F-hom (γ ⋆⟨ Γ ⟩ δ , C .⋆IdL (C .id) (~ i))) ⟩
        F .F-hom (γ ⋆⟨ Γ ⟩ δ , C .id ⋆⟨ C ⟩ C .id)
          ≡⟨ F .F-seq (γ , C .id) (δ , C .id) ⟩
        F .F-hom (γ , C .id) ⋆⟨ D ⟩ F .F-hom (δ , C .id) ∎))

    λFl : Functor (C ×C Γ) D → Functor Γ (FUNCTOR C D)
    λFl F = λF (F ∘F (Snd Γ C ,F Fst Γ C))