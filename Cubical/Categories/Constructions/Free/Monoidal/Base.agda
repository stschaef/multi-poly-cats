{- Free monoidal category generated by a type of objects -}
{-# OPTIONS --safe #-}
module Cubical.Categories.Constructions.Free.Monoidal.Base where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma hiding (_×_)
import Cubical.Data.Sigma as Σ

open import Cubical.Categories.Category.Base
open import Cubical.Categories.Constructions.BinProduct hiding (_,F_; _×F_)
open import Cubical.Categories.Constructions.BinProduct.Monoidal
open import Cubical.Categories.Isomorphism
open import Cubical.Categories.Monoidal.Base
open import Cubical.Categories.Monoidal.Functor
open import Cubical.Categories.Functor
open import Cubical.Categories.NaturalTransformation
open import Cubical.Categories.Constructions.Free.Category hiding (ε)

open import Cubical.Categories.Displayed.Base
open import Cubical.Categories.Displayed.More
open import Cubical.Categories.Displayed.Functor
open import Cubical.Categories.Displayed.NaturalTransformation
open import Cubical.Categories.Displayed.NaturalIsomorphism
open import Cubical.Categories.Displayed.Section
open import Cubical.Categories.Displayed.Monoidal.Base
open import Cubical.Categories.Displayed.Constructions.Reindex.Base
open import Cubical.Categories.Displayed.Constructions.Reindex.Monoidal
  as Monoidal
open import Cubical.Categories.Displayed.Constructions.Weaken.Monoidal
import Cubical.Categories.Displayed.Constructions.Weaken as Wk
open import Cubical.Categories.Displayed.Instances.Arrow.Base
open import Cubical.Categories.Displayed.Instances.Arrow.Monoidal
open import Cubical.Categories.Displayed.Constructions.IsoFiber.Base
  hiding (IsoFiber)
open import Cubical.Categories.Displayed.Constructions.IsoFiber.Monoidal

private
  variable
    ℓ ℓQ ℓQ' ℓC ℓC' ℓCᴰ ℓCᴰ' ℓD ℓD' ℓDᴰ ℓDᴰ' : Level

open Category
open Functor
open NatTrans
open NatIso
open NatTransᴰ
open NatIsoᴰ
open isIso
open isIsoᴰ
open Section
open Functorᴰ
module _ (X : Type ℓ) where
  data MonOb : Type ℓ where
    ↑ : X → MonOb
    unit : MonOb
    _⊗_ : MonOb → MonOb → MonOb

  data MonMor : MonOb → MonOb → Type ℓ where
    idₑ : ∀ {x} → MonMor x x
    _⋆ₑ_ : ∀ {x y z} → MonMor x y → MonMor y z → MonMor x z
    ⋆ₑIdL : ∀ {x y} (e : MonMor x y) → idₑ ⋆ₑ e ≡ e
    ⋆ₑIdR : ∀ {x y} (e : MonMor x y) → e ⋆ₑ idₑ ≡ e
    ⋆ₑAssoc : ∀ {x y z D} (e : MonMor x y)(f : MonMor y z)(g : MonMor z D)
              → (e ⋆ₑ f) ⋆ₑ g ≡ e ⋆ₑ (f ⋆ₑ g)
    isSetHomₑ : ∀ {x y} → isSet (MonMor x y)

    _⊗_ : ∀ {x x' y y'} → MonMor x y → MonMor x' y' → MonMor (x ⊗ x') (y ⊗ y')
    ⊗id : ∀ {x y} → idₑ ⊗ idₑ ≡ idₑ {x ⊗ y}
    ⊗⋆  : ∀ {x x' y y' z z'}
      (f : MonMor x y) (g : MonMor y z)
      (f' : MonMor x' y') (g' : MonMor y' z')
      → (f ⋆ₑ g) ⊗ (f' ⋆ₑ g') ≡ ((f ⊗ f') ⋆ₑ (g ⊗ g'))

    α : ∀ {x y z} → MonMor (x ⊗ (y ⊗ z)) ((x ⊗ y) ⊗ z)
    α⁻ : ∀ {x y z} → MonMor ((x ⊗ y) ⊗ z) (x ⊗ (y ⊗ z))
    α-nat : ∀ {x x' y y' z z'} →
      (f : MonMor x x')(g : MonMor y y')(h : MonMor z z')
      → ((f ⊗ (g ⊗ h)) ⋆ₑ α) ≡ (α ⋆ₑ ((f ⊗ g) ⊗ h))
    α⋆α⁻ : ∀ {x y z} → α {x}{y}{z} ⋆ₑ α⁻ ≡ idₑ
    α⁻⋆α : ∀ {x y z} → α⁻ {x}{y}{z} ⋆ₑ α ≡ idₑ

    η : ∀ {x} → MonMor (unit ⊗ x) x
    η⁻ : ∀ {x} → MonMor x (unit ⊗ x)
    η-nat : ∀ {x y} (f : MonMor x y) → ((idₑ ⊗ f) ⋆ₑ η) ≡ (η ⋆ₑ f)
    η⋆η⁻ : ∀ {x} → (η {x} ⋆ₑ η⁻) ≡ idₑ
    η⁻⋆η : ∀ {x} → (η⁻ {x} ⋆ₑ η) ≡ idₑ

    ρ : ∀ {x} → MonMor (x ⊗ unit) x
    ρ⁻ : ∀ {x} → MonMor x (x ⊗ unit)
    ρ-nat : ∀ {x y} (f : MonMor x y) → ((f ⊗ idₑ) ⋆ₑ ρ) ≡ (ρ ⋆ₑ f)
    ρ⋆ρ⁻ : ∀ {x} → (ρ {x} ⋆ₑ ρ⁻) ≡ idₑ
    ρ⁻⋆ρ : ∀ {x} → (ρ⁻ {x} ⋆ₑ ρ) ≡ idₑ

    pentagon : ∀ {w x y z} →
      (idₑ {w} ⊗ α {x}{y}{z}) ⋆ₑ (α ⋆ₑ (α ⊗ idₑ)) ≡ (α ⋆ₑ α)
    triangle : ∀ {x y} → α ⋆ₑ (ρ {x} ⊗ idₑ) ≡ (idₑ ⊗ (η {y}))

  |FreeMonoidalCategory| : Category ℓ ℓ
  |FreeMonoidalCategory| .ob = MonOb
  |FreeMonoidalCategory| .Hom[_,_] = MonMor
  |FreeMonoidalCategory| .id = idₑ
  |FreeMonoidalCategory| ._⋆_ = _⋆ₑ_
  |FreeMonoidalCategory| .⋆IdL = ⋆ₑIdL
  |FreeMonoidalCategory| .⋆IdR = ⋆ₑIdR
  |FreeMonoidalCategory| .⋆Assoc = ⋆ₑAssoc
  |FreeMonoidalCategory| .isSetHom = isSetHomₑ

  FreeMonoidalCategoryStr : TensorStr |FreeMonoidalCategory|
  FreeMonoidalCategoryStr .TensorStr.─⊗─ .F-ob (x , y) = x ⊗ y
  FreeMonoidalCategoryStr .TensorStr.─⊗─ .F-hom (f , g) = f ⊗ g
  FreeMonoidalCategoryStr .TensorStr.─⊗─ .F-id = ⊗id
  FreeMonoidalCategoryStr .TensorStr.─⊗─ .F-seq f g =
    ⊗⋆ (f .fst) (g .fst) (f .snd) (g .snd)
  FreeMonoidalCategoryStr .TensorStr.unit = unit

  FreeMonoidalCategory : MonoidalCategory ℓ ℓ
  FreeMonoidalCategory .MonoidalCategory.C = |FreeMonoidalCategory|
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.tenstr =
    FreeMonoidalCategoryStr
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.α .trans .N-ob x =
    α
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.α .trans .N-hom f =
    α-nat _ _ _
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.α .nIso x .inv = α⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.α .nIso x .sec =
    α⁻⋆α
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.α .nIso x .ret =
    α⋆α⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.η .trans .N-ob x =
    η
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.η .trans .N-hom =
    η-nat
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.η .nIso x .inv =
    η⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.η .nIso x .sec =
    η⁻⋆η
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.η .nIso x .ret =
    η⋆η⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.ρ .trans .N-ob x =
    ρ
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.ρ .trans .N-hom =
    ρ-nat
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.ρ .nIso x .inv =
    ρ⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.ρ .nIso x .sec =
    ρ⁻⋆ρ
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.ρ .nIso x .ret =
    ρ⋆ρ⁻
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.pentagon w x y z =
    pentagon
  FreeMonoidalCategory .MonoidalCategory.monstr .MonoidalStr.triangle x y =
    triangle

  module _ (Mᴰ : MonoidalCategoryᴰ FreeMonoidalCategory ℓC ℓC') where
    private
      module Mᴰ = MonoidalCategoryᴰ Mᴰ
    module _ (ı : ∀ (x : X) → Mᴰ.ob[ ↑ x ]) where

      elim-ob : ∀ x → Mᴰ.ob[ x ]
      elim-ob (↑ x) = ı x
      elim-ob unit = Mᴰ.unitᴰ
      elim-ob (x ⊗ y) = elim-ob x Mᴰ.⊗ᴰ elim-ob y

      elim-hom : ∀ {x y}(f : |FreeMonoidalCategory| [ x , y ])
        → Mᴰ.Hom[ f ][ elim-ob x , elim-ob y ]
      elim-hom idₑ = Mᴰ.idᴰ
      elim-hom (f ⋆ₑ g) = elim-hom f Mᴰ.⋆ᴰ elim-hom g
      elim-hom (⋆ₑIdL f i) = Mᴰ.⋆IdLᴰ (elim-hom f) i
      elim-hom (⋆ₑIdR f i) = Mᴰ.⋆IdRᴰ (elim-hom f) i
      elim-hom (⋆ₑAssoc f g h i) =
        Mᴰ.⋆Assocᴰ (elim-hom f)(elim-hom g)(elim-hom h) i
      elim-hom (isSetHomₑ f g p q i j) =
        isSetHomᴰ' Mᴰ.Cᴰ
          (elim-hom f) (elim-hom g)
          (cong elim-hom p) (cong elim-hom q)
          i j
      elim-hom (f ⊗ g) = elim-hom f Mᴰ.⊗ₕᴰ elim-hom g
      elim-hom (⊗id i) = Mᴰ.─⊗ᴰ─ .F-idᴰ i
      elim-hom (⊗⋆ f g f' g' i) =
        Mᴰ.─⊗ᴰ─ .F-seqᴰ
          ((elim-hom f) , (elim-hom f'))
          (elim-hom g , elim-hom g')
          i
      elim-hom α = Mᴰ.αᴰ⟨ _ , _ , _ ⟩
      elim-hom (α-nat f g h i) =
        Mᴰ.αᴰ .transᴰ .N-homᴰ ((elim-hom f) , (elim-hom g) , (elim-hom h)) i
      elim-hom α⁻ = Mᴰ.αᴰ .nIsoᴰ _ .invᴰ
      elim-hom (α⋆α⁻ i) = Mᴰ.αᴰ .nIsoᴰ _ .retᴰ i
      elim-hom (α⁻⋆α i) = Mᴰ.αᴰ .nIsoᴰ _ .secᴰ i
      elim-hom η = Mᴰ.ηᴰ⟨ _ ⟩
      elim-hom (η-nat f i) = Mᴰ.ηᴰ .transᴰ .N-homᴰ (elim-hom f) i
      elim-hom η⁻ = Mᴰ.ηᴰ .nIsoᴰ _ .invᴰ
      elim-hom (η⋆η⁻ i) = Mᴰ.ηᴰ .nIsoᴰ _ .retᴰ i
      elim-hom (η⁻⋆η i) = Mᴰ.ηᴰ .nIsoᴰ _ .secᴰ i
      elim-hom ρ = Mᴰ.ρᴰ⟨ _ ⟩
      elim-hom (ρ-nat f i) = Mᴰ.ρᴰ .transᴰ .N-homᴰ (elim-hom f) i
      elim-hom ρ⁻ = Mᴰ.ρᴰ .nIsoᴰ _ .invᴰ
      elim-hom (ρ⋆ρ⁻ i) = Mᴰ.ρᴰ .nIsoᴰ _ .retᴰ i
      elim-hom (ρ⁻⋆ρ i) = Mᴰ.ρᴰ .nIsoᴰ _ .secᴰ i
      elim-hom (pentagon i) = Mᴰ.pentagonᴰ _ _ _ _ i
      elim-hom (triangle i) = Mᴰ.triangleᴰ _ _ i

      elim : GlobalSection Mᴰ.Cᴰ
      elim .F-obᴰ = elim-ob
      elim .F-homᴰ = elim-hom
      elim .F-idᴰ = refl
      elim .F-seqᴰ _ _ = refl

  module _ (M : MonoidalCategory ℓC ℓC') where
    private
      module M = MonoidalCategory M
    module _ (ı : X → M.C .ob) where
      private
        Mᴰ = weaken FreeMonoidalCategory M
        module Mᴰ = MonoidalCategoryᴰ Mᴰ
      open StrongMonoidalFunctor
      open StrongMonoidalStr
      open LaxMonoidalStr
      -- TODO: we can probably show that elim is a "strong monoidal
      -- section" and then get this out as a general principle but we
      -- haven't needed strong monoidal sections for anything
      -- else so far so I'll just do this manually
      rec : StrongMonoidalFunctor FreeMonoidalCategory M
      rec .F = Wk.introS⁻ (elim Mᴰ ı)
      rec .strmonstr .laxmonstr .ε = M.id
      rec .strmonstr .laxmonstr .μ .N-ob x = M.id
      rec .strmonstr .laxmonstr .μ .N-hom f =
        M.⋆IdR _ ∙ sym (M.⋆IdL _)
      rec .strmonstr .laxmonstr .αμ-law x y z =
        M.⋆IdR _
        ∙ cong₂ M._⋆_ refl (M.─⊗─ .F-id)
        ∙ M.⋆IdR _ ∙ sym (M.⋆IdL _)
        ∙ cong₂ M._⋆_ (sym (M.─⊗─ .F-id)) refl
        ∙ cong₂ M._⋆_ (sym (M.⋆IdR _)) refl
      rec .strmonstr .laxmonstr .ηε-law x =
        cong₂ M._⋆_ (M.⋆IdR _ ∙ M.─⊗─ .F-id) refl ∙ M.⋆IdL _
      rec .strmonstr .laxmonstr .ρε-law x =
        cong₂ M._⋆_ (M.⋆IdR _ ∙ M.─⊗─ .F-id) refl ∙ M.⋆IdL _
      rec .strmonstr .ε-isIso = idCatIso .snd
      rec .strmonstr .μ-isIso _ = idCatIso .snd

    module _ (G H : StrongMonoidalFunctor FreeMonoidalCategory M) where
      private
        module G = StrongMonoidalFunctor G
        module H = StrongMonoidalFunctor H
      uniq : ∀ (ı≅ : ∀ x → CatIso M.C (G.F ⟅ ↑ x ⟆ ) (H.F ⟅ ↑ x ⟆ ))
        → G.F ≅ᶜ H.F
      uniq ı≅ = IsoReflection (GlobalSectionReindex→Section _ _
        (elim (IsoComma G H) ı≅))

  module _
      (M : MonoidalCategory ℓD ℓD')
      (G : StrongMonoidalFunctor M FreeMonoidalCategory)
      where
    private
      module M = MonoidalCategory M
      module G = StrongMonoidalFunctor G
    module _
           (ı : X → M.ob)
           (ı≅ : ∀ x → CatIso |FreeMonoidalCategory| (G.F ⟅ ı x ⟆) (↑ x))
      where

      mkRetract : Σ[ G⁻ ∈ Functor |FreeMonoidalCategory| M.C ]
        G.F ∘F G⁻ ≅ᶜ Id
      mkRetract = IsoFiberReflection (G.F) S
        where
          Motive : MonoidalCategoryᴰ FreeMonoidalCategory _ _
          Motive = IsoFiber G
          module Motive = MonoidalCategoryᴰ Motive
          S : GlobalSection Motive.Cᴰ
          S = elim Motive (λ x → (ı x) , (invIso (ı≅ x)))
