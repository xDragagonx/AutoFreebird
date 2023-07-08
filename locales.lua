Global("locales", {})
--create tables of each language
locales["eng_eu"]={}
locales["rus"]={}
locales["fr"]={}
locales["ger"]={}
locales["tr"]={}
--Player doesn't own Wandering Mask
locales["eng_eu"][ "NoWanderingMask" ] = "You don't own the Wandering Actor Mask"
locales["fr"][ "NoWanderingMask" ] = "Vous ne poss/233dez pas le masque d'acteur errant"
locales["rus"][ "NoWanderingMask" ] = "У вас нет маски странствующего актера"
locales["ger"][ "NoWanderingMask" ] = "Sie besitzen die Wandering Actor-Maske nicht"
locales["tr"][ "NoWanderingMask" ] = "Wandering Actor Mask'e sahip de/287ilsiniz"
--Player doesn't own Freebird Mask
locales["eng_eu"][ "NoFreeBirdMask" ] = "You don't own the Free Bird Mask"
locales["fr"][ "NoFreeBirdMask" ] = "Vous ne poss/233dez pas le masque d'oiseau gratuit"
locales["rus"][ "NoFreeBirdMask" ] = "У вас нет маски Free Bird."
locales["ger"][ "NoFreeBirdMask" ] = "Sie besitzen die Free Bird Mask nicht"
locales["tr"][ "NoFreeBirdMask" ] = "Free Bird Mask'e sahip de/287ilsiniz"
--Theatre location
locales["eng_eu"][ "TheatreLocation" ] = "Miracle Theatre"
locales["fr"][ "TheatreLocation" ] = "Th/233/226tre Miracle"
locales["rus"][ "TheatreLocation" ] = "Чудо-театр"
locales["ger"][ "TheatreLocation" ] = "Wundertheater"
locales["tr"][ "TheatreLocation" ] = "Mucize Tiyatrosu"

locales = locales[common.GetLocalization()] -- trims all other languages except the one that common.getlocal got.