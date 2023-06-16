{-# OPTIONS --safe #-}

module Cubical.Categories.Instances.Posets.Base where

open import Cubical.Foundations.Prelude
open import Cubical.Categories.Category
open import Cubical.Relation.Binary.Preorder
open import Cubical.Relation.Binary.Poset
open import Cubical.Categories.Constructions.FullSubcategory

open import Cubical.Categories.Instances.Preorders.Base
open import Cubical.Categories.Instances.Preorders.Monotone
open import Cubical.Categories.Instances.Preorders.Monotone.Adjoint


open import Cubical.Categories.Constructions.Subcategory

private
  variable
    ℓ ℓ' : Level

open Category
open PreorderStr

-- Category of Posets
POSET : (ℓ ℓ' : Level) → Category _ _
POSET ℓ ℓ' = FullSubcategory
  (PREORDER ℓ ℓ')
  λ p → IsPoset (p .snd ._≤_)


-- Displayed Poset for picking out Posets
-- and monotone functions with adjoints
BothAdjDisplay : DisplayedPoset (PREORDER ℓ ℓ') {ℓ-max ℓ ℓ'}
BothAdjDisplay = record
  { D-ob = λ p → IsPoset (p .snd ._≤_)
  ; D-Hom_[_,_] = λ f x y → HasBothAdj f
  ; isPropHomf = (isPropHasBothAdj _)
  ; D-id = IdHasBothAdj
  ; _D-⋆_ = CompHasBothAdj
  }

-- Category of Posets w/ Both Adjoints
POSETADJ : (ℓ ℓ' : Level) → Category _ _
POSETADJ ℓ ℓ' = Grothendieck
  (PREORDER ℓ ℓ')
  (DisplayedPoset→Cat (PREORDER ℓ ℓ') BothAdjDisplay)

-- Displayed Poset for picking out Posets
-- and monotone functions with left adjoints
LeftAdjDisplay : DisplayedPoset (PREORDER ℓ ℓ') {ℓ-max ℓ ℓ'}
LeftAdjDisplay = record
  { D-ob = λ p → IsPoset (p .snd ._≤_)
  ; D-Hom_[_,_] = λ f x y → HasLeftAdj f
  ; isPropHomf = (isPropHasLeftAdj _)
  ; D-id = IdHasLeftAdj
  ; _D-⋆_ = CompHasLeftAdj
  }

POSETADJL : (ℓ ℓ' : Level) → Category _ _
POSETADJL ℓ ℓ' = Grothendieck
  (PREORDER ℓ ℓ')
  (DisplayedPoset→Cat (PREORDER ℓ ℓ') LeftAdjDisplay)

-- Displayed Poset for picking out Posets
-- and monotone functions with right adjoints
RightAdjDisplay : DisplayedPoset (PREORDER ℓ ℓ') {ℓ-max ℓ ℓ'}
RightAdjDisplay = record
  { D-ob = λ p → IsPoset (p .snd ._≤_)
  ; D-Hom_[_,_] = λ f x y → HasRightAdj f
  ; isPropHomf = (isPropHasRightAdj _)
  ; D-id = IdHasRightAdj
  ; _D-⋆_ = CompHasRightAdj
  }

POSETADJR : (ℓ ℓ' : Level) → Category _ _
POSETADJR ℓ ℓ' = Grothendieck
  (PREORDER ℓ ℓ')
  (DisplayedPoset→Cat (PREORDER ℓ ℓ') RightAdjDisplay)
