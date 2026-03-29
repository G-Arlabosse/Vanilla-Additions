local CARD_ID = Isaac.GetCardIdByName("Reverse Card")

local CARD_FLIPS = {
    -- Tarot card -> Reverse Tarot Card
    [Card.CARD_FOOL] = Card.CARD_REVERSE_FOOL,
    [Card.CARD_MAGICIAN] = Card.CARD_REVERSE_MAGICIAN,
    [Card.CARD_HIGH_PRIESTESS] = Card.CARD_REVERSE_HIGH_PRIESTESS,
    [Card.CARD_EMPRESS] = Card.CARD_REVERSE_EMPRESS,
    [Card.CARD_EMPEROR] = Card.CARD_REVERSE_EMPEROR,
    [Card.CARD_HIEROPHANT] = Card.CARD_REVERSE_HIEROPHANT,
    [Card.CARD_LOVERS] = Card.CARD_REVERSE_LOVERS,
    [Card.CARD_CHARIOT] = Card.CARD_REVERSE_CHARIOT,
    [Card.CARD_JUSTICE] = Card.CARD_REVERSE_JUSTICE,
    [Card.CARD_HERMIT] = Card.CARD_REVERSE_HERMIT,
    [Card.CARD_WHEEL_OF_FORTUNE] = Card.CARD_REVERSE_WHEEL_OF_FORTUNE,
    [Card.CARD_STRENGTH] = Card.CARD_REVERSE_STRENGTH,
    [Card.CARD_HANGED_MAN] = Card.CARD_REVERSE_HANGED_MAN,
    [Card.CARD_DEATH] = Card.CARD_REVERSE_DEATH,
    [Card.CARD_TEMPERANCE] = Card.CARD_REVERSE_TEMPERANCE,
    [Card.CARD_DEVIL] = Card.CARD_REVERSE_DEVIL,
    [Card.CARD_TOWER] = Card.CARD_REVERSE_TOWER,
    [Card.CARD_STARS] = Card.CARD_REVERSE_STARS,
    [Card.CARD_MOON] = Card.CARD_REVERSE_MOON,
    [Card.CARD_SUN] = Card.CARD_REVERSE_SUN,
    [Card.CARD_JUDGEMENT] = Card.CARD_REVERSE_JUDGEMENT,
    [Card.CARD_WORLD] = Card.CARD_REVERSE_WORLD,

    -- Reverse Tarot card -> Tarot Card
    [Card.CARD_REVERSE_FOOL] = Card.CARD_FOOL,
    [Card.CARD_REVERSE_MAGICIAN] = Card.CARD_MAGICIAN,
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = Card.CARD_HIGH_PRIESTESS,
    [Card.CARD_REVERSE_EMPRESS] = Card.CARD_EMPRESS,
    [Card.CARD_REVERSE_EMPEROR] = Card.CARD_EMPEROR,
    [Card.CARD_REVERSE_HIEROPHANT] = Card.CARD_HIEROPHANT,
    [Card.CARD_REVERSE_LOVERS] = Card.CARD_LOVERS,
    [Card.CARD_REVERSE_CHARIOT] = Card.CARD_CHARIOT,
    [Card.CARD_REVERSE_JUSTICE] = Card.CARD_JUSTICE,
    [Card.CARD_REVERSE_HERMIT] = Card.CARD_HERMIT,
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = Card.CARD_WHEEL_OF_FORTUNE,
    [Card.CARD_REVERSE_STRENGTH] = Card.CARD_STRENGTH,
    [Card.CARD_REVERSE_HANGED_MAN] = Card.CARD_HANGED_MAN,
    [Card.CARD_REVERSE_DEATH] = Card.CARD_DEATH,
    [Card.CARD_REVERSE_TEMPERANCE] = Card.CARD_TEMPERANCE,
    [Card.CARD_REVERSE_DEVIL] = Card.CARD_DEVIL,
    [Card.CARD_REVERSE_TOWER] = Card.CARD_TOWER,
    [Card.CARD_REVERSE_STARS] = Card.CARD_STARS,
    [Card.CARD_REVERSE_MOON] = Card.CARD_MOON,
    [Card.CARD_REVERSE_SUN] = Card.CARD_SUN,
    [Card.CARD_REVERSE_JUDGEMENT] = Card.CARD_JUDGEMENT,
    [Card.CARD_REVERSE_WORLD] = Card.CARD_WORLD
}

local ITEM_FLIPS = {
    [CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = {CollectibleType.COLLECTIBLE_SATANIC_BIBLE},
    [CollectibleType.COLLECTIBLE_SATANIC_BIBLE] = {CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS},
    [CollectibleType.COLLECTIBLE_MR_BOOM] = {CollectibleType.COLLECTIBLE_MAMA_MEGA},
    [CollectibleType.COLLECTIBLE_MAMA_MEGA] = {CollectibleType.COLLECTIBLE_MR_BOOM},
    [CollectibleType.COLLECTIBLE_NOTCHED_AXE] = {CollectibleType.COLLECTIBLE_DATAMINER},
    [CollectibleType.COLLECTIBLE_DATAMINER] = {CollectibleType.COLLECTIBLE_NOTCHED_AXE},
    [CollectibleType.COLLECTIBLE_PRAYER_CARD] = {CollectibleType.COLLECTIBLE_THE_NAIL},
    [CollectibleType.COLLECTIBLE_THE_NAIL] = {CollectibleType.COLLECTIBLE_PRAYER_CARD},
    [CollectibleType.COLLECTIBLE_CONVERTER] = {CollectibleType.COLLECTIBLE_GUPPYS_PAW},
    [CollectibleType.COLLECTIBLE_GUPPYS_PAW] = {CollectibleType.COLLECTIBLE_CONVERTER},
    [CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = {CollectibleType.COLLECTIBLE_PLAN_C},
    [CollectibleType.COLLECTIBLE_PLAN_C] = {CollectibleType.COLLECTIBLE_FORGET_ME_NOW},
    [CollectibleType.COLLECTIBLE_ISAACS_TEARS] = {CollectibleType.COLLECTIBLE_TAMMYS_HEAD},
    [CollectibleType.COLLECTIBLE_TAMMYS_HEAD] = {CollectibleType.COLLECTIBLE_ISAACS_TEARS},
    [CollectibleType.COLLECTIBLE_SCISSORS] = {CollectibleType.COLLECTIBLE_PINKING_SHEARS},
    [CollectibleType.COLLECTIBLE_PINKING_SHEARS] = {CollectibleType.COLLECTIBLE_SCISSORS},
    [CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS] = {CollectibleType.COLLECTIBLE_HOURGLASS},
    [CollectibleType.COLLECTIBLE_HOURGLASS] = {CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS},
    [CollectibleType.COLLECTIBLE_YUM_HEART] = {CollectibleType.COLLECTIBLE_YUCK_HEART},
    [CollectibleType.COLLECTIBLE_YUCK_HEART] = {CollectibleType.COLLECTIBLE_YUM_HEART},
    [CollectibleType.COLLECTIBLE_WOODEN_NICKEL] = {CollectibleType.COLLECTIBLE_CROOKED_PENNY},
    [CollectibleType.COLLECTIBLE_CROOKED_PENNY] = {CollectibleType.COLLECTIBLE_WOODEN_NICKEL},
    [CollectibleType.COLLECTIBLE_VOID] = {CollectibleType.COLLECTIBLE_ABYSS},
    [CollectibleType.COLLECTIBLE_ABYSS] = {CollectibleType.COLLECTIBLE_VOID},
    [CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES] = {CollectibleType.COLLECTIBLE_LEMEGETON},
    [CollectibleType.COLLECTIBLE_LEMEGETON] = {CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES},
    [CollectibleType.COLLECTIBLE_SAD_ONION] = {CollectibleType.COLLECTIBLE_DEAD_ONION},
    [CollectibleType.COLLECTIBLE_DEAD_ONION] = {CollectibleType.COLLECTIBLE_SAD_ONION},
    [CollectibleType.COLLECTIBLE_BIRDS_EYE] = {CollectibleType.COLLECTIBLE_GHOST_PEPPER},
    [CollectibleType.COLLECTIBLE_GHOST_PEPPER] = {CollectibleType.COLLECTIBLE_BIRDS_EYE},
    [CollectibleType.COLLECTIBLE_PHD] = {CollectibleType.COLLECTIBLE_FALSE_PHD},
    [CollectibleType.COLLECTIBLE_FALSE_PHD] = {CollectibleType.COLLECTIBLE_PHD},
    [CollectibleType.COLLECTIBLE_TINY_PLANET] = {CollectibleType.COLLECTIBLE_ANTI_GRAVITY},
    [CollectibleType.COLLECTIBLE_ANTI_GRAVITY] = {CollectibleType.COLLECTIBLE_TINY_PLANET},
    [CollectibleType.COLLECTIBLE_LADDER] = {CollectibleType.COLLECTIBLE_TRANSCENDENCE},
    [CollectibleType.COLLECTIBLE_TRANSCENDENCE] = {CollectibleType.COLLECTIBLE_LADDER},
    [CollectibleType.COLLECTIBLE_HALO] = {CollectibleType.COLLECTIBLE_SMB_SUPER_FAN},
    [CollectibleType.COLLECTIBLE_SMB_SUPER_FAN] = {CollectibleType.COLLECTIBLE_HALO},
    [CollectibleType.COLLECTIBLE_COMMON_COLD] = {CollectibleType.COLLECTIBLE_SINUS_INFECTION},
    [CollectibleType.COLLECTIBLE_SINUS_INFECTION] = {CollectibleType.COLLECTIBLE_COMMON_COLD},
    [CollectibleType.COLLECTIBLE_MULLIGAN] = {CollectibleType.COLLECTIBLE_PARASITOID},
    [CollectibleType.COLLECTIBLE_PARASITOID] = {CollectibleType.COLLECTIBLE_MULLIGAN},
    [CollectibleType.COLLECTIBLE_PEEPER] = {CollectibleType.COLLECTIBLE_BLOODSHOT_EYE},
    [CollectibleType.COLLECTIBLE_BLOODSHOT_EYE] = {CollectibleType.COLLECTIBLE_PEEPER},
    [CollectibleType.COLLECTIBLE_DEAD_DOVE] = {CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT},
    [CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT] = {CollectibleType.COLLECTIBLE_DEAD_DOVE},
    [CollectibleType.COLLECTIBLE_SISSY_LONGLEGS] = {CollectibleType.COLLECTIBLE_DADDY_LONGLEGS},
    [CollectibleType.COLLECTIBLE_DADDY_LONGLEGS] = {CollectibleType.COLLECTIBLE_SISSY_LONGLEGS},
    [CollectibleType.COLLECTIBLE_REVELATION] = {CollectibleType.COLLECTIBLE_BRIMSTONE},
    [CollectibleType.COLLECTIBLE_BRIMSTONE] = {CollectibleType.COLLECTIBLE_REVELATION},
    [CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = {CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW},
    [CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW] = {CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE},
    [CollectibleType.COLLECTIBLE_SPIDERBABY] = {CollectibleType.COLLECTIBLE_KEEPERS_KIN},
    [CollectibleType.COLLECTIBLE_KEEPERS_KIN] = {CollectibleType.COLLECTIBLE_SPIDERBABY},
    [CollectibleType.COLLECTIBLE_EUCHARIST] = {CollectibleType.COLLECTIBLE_GOAT_HEAD},
    [CollectibleType.COLLECTIBLE_GOAT_HEAD] = {CollectibleType.COLLECTIBLE_EUCHARIST},
    [CollectibleType.COLLECTIBLE_STOP_WATCH] = {CollectibleType.COLLECTIBLE_BROKEN_WATCH},
    [CollectibleType.COLLECTIBLE_BROKEN_WATCH] = {CollectibleType.COLLECTIBLE_STOP_WATCH},
    [CollectibleType.COLLECTIBLE_TRINITY_SHIELD] = {CollectibleType.COLLECTIBLE_INFAMY},
    [CollectibleType.COLLECTIBLE_INFAMY] = {CollectibleType.COLLECTIBLE_TRINITY_SHIELD},
    [CollectibleType.COLLECTIBLE_BFFS] = {CollectibleType.COLLECTIBLE_HIVE_MIND},
    [CollectibleType.COLLECTIBLE_HIVE_MIND] = {CollectibleType.COLLECTIBLE_BFFS},
    [CollectibleType.COLLECTIBLE_FIRE_MIND] = {CollectibleType.COLLECTIBLE_EXPLOSIVO},
    [CollectibleType.COLLECTIBLE_EXPLOSIVO] = {CollectibleType.COLLECTIBLE_FIRE_MIND},
    [CollectibleType.COLLECTIBLE_GODHEAD] = {CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT},
    [CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = {CollectibleType.COLLECTIBLE_GODHEAD},
    [CollectibleType.COLLECTIBLE_20_20] = {CollectibleType.COLLECTIBLE_THE_WIZ},
    [CollectibleType.COLLECTIBLE_THE_WIZ] = {CollectibleType.COLLECTIBLE_20_20},
    [CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION] = {CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION},
    [CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION] = {CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION},
    [CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = {CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN},
    [CollectibleType.COLLECTIBLE_DARK_PRINCES_CROWN] = {CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT},
    [CollectibleType.COLLECTIBLE_VARICOSE_VEINS] = {CollectibleType.COLLECTIBLE_VASCULITIS},
    [CollectibleType.COLLECTIBLE_VASCULITIS] = {CollectibleType.COLLECTIBLE_VARICOSE_VEINS},
    [CollectibleType.COLLECTIBLE_BRITTLE_BONES] = {CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE},
    [CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE] = {CollectibleType.COLLECTIBLE_BRITTLE_BONES},
    [CollectibleType.COLLECTIBLE_POLYDACTYLY] = {CollectibleType.COLLECTIBLE_BELLY_BUTTON},
    [CollectibleType.COLLECTIBLE_BELLY_BUTTON] = {CollectibleType.COLLECTIBLE_POLYDACTYLY},
    [CollectibleType.COLLECTIBLE_FINGER] = {CollectibleType.COLLECTIBLE_POINTY_RIB},
    [CollectibleType.COLLECTIBLE_POINTY_RIB] = {CollectibleType.COLLECTIBLE_FINGER},
    [CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION] = {CollectibleType.COLLECTIBLE_PACT},
    [CollectibleType.COLLECTIBLE_PACT] = {CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION},
    [CollectibleType.COLLECTIBLE_SOUL_LOCKET] = {CollectibleType.COLLECTIBLE_CANDY_HEART},
    [CollectibleType.COLLECTIBLE_CANDY_HEART] = {CollectibleType.COLLECTIBLE_SOUL_LOCKET},
    [CollectibleType.COLLECTIBLE_CANDLE] = {CollectibleType.COLLECTIBLE_BLACK_CANDLE},
    [CollectibleType.COLLECTIBLE_BLACK_CANDLE] = {CollectibleType.COLLECTIBLE_CANDLE},
    [CollectibleType.COLLECTIBLE_PASCHAL_CANDLE] = {CollectibleType.COLLECTIBLE_RED_CANDLE},
    [CollectibleType.COLLECTIBLE_RED_CANDLE] = {CollectibleType.COLLECTIBLE_PASCHAL_CANDLE},
    [CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = {CollectibleType.COLLECTIBLE_VOODOO_HEAD},
    [CollectibleType.COLLECTIBLE_VOODOO_HEAD] = {CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER},
    [CollectibleType.COLLECTIBLE_ZODIAC] = {CollectibleType.COLLECTIBLE_MARKED},
    [CollectibleType.COLLECTIBLE_MARKED] = {CollectibleType.COLLECTIBLE_ZODIAC},
    [CollectibleType.COLLECTIBLE_BBF] = {CollectibleType.COLLECTIBLE_BLUE_BABYS_ONLY_FRIEND},
    [CollectibleType.COLLECTIBLE_BLUE_BABYS_ONLY_FRIEND] = {CollectibleType.COLLECTIBLE_BBF},
    [CollectibleType.COLLECTIBLE_DEAD_BIRD] = {CollectibleType.COLLECTIBLE_BIRD_CAGE},
    [CollectibleType.COLLECTIBLE_BIRD_CAGE] = {CollectibleType.COLLECTIBLE_DEAD_BIRD},
    [CollectibleType.COLLECTIBLE_HABIT] = {CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES},
    [CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES] = {CollectibleType.COLLECTIBLE_HABIT},
    [CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR] = {CollectibleType.COLLECTIBLE_NUMBER_TWO},
    [CollectibleType.COLLECTIBLE_NUMBER_TWO] = {CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR},
    [CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION] = {CollectibleType.COLLECTIBLE_PURGATORY},
    [CollectibleType.COLLECTIBLE_PURGATORY] = {CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION},
    [CollectibleType.COLLECTIBLE_LOST_SOUL] = {CollectibleType.COLLECTIBLE_HUNGRY_SOUL},
    [CollectibleType.COLLECTIBLE_HUNGRY_SOUL] = {CollectibleType.COLLECTIBLE_LOST_SOUL},
    [CollectibleType.COLLECTIBLE_SPIDER_BITE] = {CollectibleType.COLLECTIBLE_INTRUDER},
    [CollectibleType.COLLECTIBLE_INTRUDER] = {CollectibleType.COLLECTIBLE_SPIDER_BITE},
    [CollectibleType.COLLECTIBLE_INFESTATION_2] = {CollectibleType.COLLECTIBLE_MUTANT_SPIDER},
    [CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = {CollectibleType.COLLECTIBLE_INFESTATION_2},
    [CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES] = {CollectibleType.COLLECTIBLE_CUBE_OF_MEAT},
    [CollectibleType.COLLECTIBLE_CUBE_OF_MEAT] = {CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES},
    [CollectibleType.COLLECTIBLE_WHITE_PONY] = {CollectibleType.COLLECTIBLE_PONY},
    [CollectibleType.COLLECTIBLE_PONY] = {CollectibleType.COLLECTIBLE_WHITE_PONY},
    [CollectibleType.COLLECTIBLE_SCOOPER] = {CollectibleType.COLLECTIBLE_POTATO_PEELER},
    [CollectibleType.COLLECTIBLE_POTATO_PEELER] = {CollectibleType.COLLECTIBLE_SCOOPER},
    [CollectibleType.COLLECTIBLE_BELT] = {CollectibleType.COLLECTIBLE_CHAMPION_BELT},
    [CollectibleType.COLLECTIBLE_CHAMPION_BELT] = {CollectibleType.COLLECTIBLE_BELT},
    [CollectibleType.COLLECTIBLE_TEAR_DETONATOR] = {CollectibleType.COLLECTIBLE_REMOTE_DETONATOR},
    [CollectibleType.COLLECTIBLE_REMOTE_DETONATOR] = {CollectibleType.COLLECTIBLE_TEAR_DETONATOR},
    [CollectibleType.COLLECTIBLE_RUBBER_CEMENT] = {CollectibleType.COLLECTIBLE_IPECAC},
    [CollectibleType.COLLECTIBLE_IPECAC] = {CollectibleType.COLLECTIBLE_RUBBER_CEMENT},
    [CollectibleType.COLLECTIBLE_MOMS_LIPSTICK] = {CollectibleType.COLLECTIBLE_SERPENTS_KISS},
    [CollectibleType.COLLECTIBLE_SERPENTS_KISS] = {CollectibleType.COLLECTIBLE_MOMS_LIPSTICK},
    [CollectibleType.COLLECTIBLE_SCHOOLBAG] = {CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING},
    [CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING] = {CollectibleType.COLLECTIBLE_SCHOOLBAG},
    [CollectibleType.COLLECTIBLE_DECAP_ATTACK] = {CollectibleType.COLLECTIBLE_FATES_REWARD},
    [CollectibleType.COLLECTIBLE_FATES_REWARD] = {CollectibleType.COLLECTIBLE_DECAP_ATTACK},
    [CollectibleType.COLLECTIBLE_REDEMPTION] = {CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT},
    [CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT] = {CollectibleType.COLLECTIBLE_REDEMPTION},
    [CollectibleType.COLLECTIBLE_HOST_HAT] = {CollectibleType.COLLECTIBLE_BERSERK},
    [CollectibleType.COLLECTIBLE_BERSERK] = {CollectibleType.COLLECTIBLE_HOST_HAT},
    [CollectibleType.COLLECTIBLE_HALLOWED_GROUND] = {CollectibleType.COLLECTIBLE_POOP},
    [CollectibleType.COLLECTIBLE_POOP] = {CollectibleType.COLLECTIBLE_HALLOWED_GROUND},
    [CollectibleType.COLLECTIBLE_RELIC] = {CollectibleType.COLLECTIBLE_BLOOD_OATH},
    [CollectibleType.COLLECTIBLE_BLOOD_OATH] = {CollectibleType.COLLECTIBLE_RELIC},
    [CollectibleType.COLLECTIBLE_CARD_READING] = {CollectibleType.COLLECTIBLE_ECHO_CHAMBER},
    [CollectibleType.COLLECTIBLE_ECHO_CHAMBER] = {CollectibleType.COLLECTIBLE_CARD_READING},
    [CollectibleType.COLLECTIBLE_SALVATION] = {CollectibleType.COLLECTIBLE_FLIP},
    [CollectibleType.COLLECTIBLE_FLIP] = {CollectibleType.COLLECTIBLE_SALVATION},
    [CollectibleType.COLLECTIBLE_SACRED_ORB] = {CollectibleType.COLLECTIBLE_CRACKED_ORB},
    [CollectibleType.COLLECTIBLE_CRACKED_ORB] = {CollectibleType.COLLECTIBLE_SACRED_ORB},
    [CollectibleType.COLLECTIBLE_BOMBER_BOY] = {CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS},
    [CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS] = {CollectibleType.COLLECTIBLE_BOMBER_BOY},
    [CollectibleType.COLLECTIBLE_PURITY] = {CollectibleType.COLLECTIBLE_BLACK_LOTUS},
    [CollectibleType.COLLECTIBLE_BLACK_LOTUS] = {CollectibleType.COLLECTIBLE_PURITY},
    [CollectibleType.COLLECTIBLE_MR_DOLLY] = {CollectibleType.COLLECTIBLE_STRAW_MAN},
    [CollectibleType.COLLECTIBLE_STRAW_MAN] = {CollectibleType.COLLECTIBLE_MR_DOLLY},
    [CollectibleType.COLLECTIBLE_BREATH_OF_LIFE] = {CollectibleType.COLLECTIBLE_TOXIC_SHOCK},
    [CollectibleType.COLLECTIBLE_TOXIC_SHOCK] = {CollectibleType.COLLECTIBLE_BREATH_OF_LIFE},
    [CollectibleType.COLLECTIBLE_MR_ME] = {CollectibleType.COLLECTIBLE_ISAACS_TOMB},
    [CollectibleType.COLLECTIBLE_ISAACS_TOMB] = {CollectibleType.COLLECTIBLE_MR_ME},
    [CollectibleType.COLLECTIBLE_GB_BUG] = {CollectibleType.COLLECTIBLE_MISSING_NO},
    [CollectibleType.COLLECTIBLE_MISSING_NO] = {CollectibleType.COLLECTIBLE_GB_BUG},
    [CollectibleType.COLLECTIBLE_CIRCLE_OF_PROTECTION] = {CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID},
    [CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID] = {CollectibleType.COLLECTIBLE_CIRCLE_OF_PROTECTION},
    [CollectibleType.COLLECTIBLE_EYE_DROPS] = {CollectibleType.COLLECTIBLE_SULFURIC_ACID},
    [CollectibleType.COLLECTIBLE_SULFURIC_ACID] = {CollectibleType.COLLECTIBLE_EYE_DROPS},
    [CollectibleType.COLLECTIBLE_TROPICAMIDE] = {CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS},
    [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = {CollectibleType.COLLECTIBLE_TROPICAMIDE},
    [CollectibleType.COLLECTIBLE_MOMS_HEELS] = {CollectibleType.COLLECTIBLE_SOCKS},
    [CollectibleType.COLLECTIBLE_SOCKS] = {CollectibleType.COLLECTIBLE_MOMS_HEELS},
    [CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = {CollectibleType.COLLECTIBLE_AZAZELS_RAGE},
    [CollectibleType.COLLECTIBLE_AZAZELS_RAGE] = {CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN},
    [CollectibleType.COLLECTIBLE_HOLY_WATER] = {CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID},
    [CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID] = {CollectibleType.COLLECTIBLE_HOLY_WATER},
    [CollectibleType.COLLECTIBLE_IRON_BAR] = {CollectibleType.COLLECTIBLE_MIDAS_TOUCH},
    [CollectibleType.COLLECTIBLE_MIDAS_TOUCH] = {CollectibleType.COLLECTIBLE_IRON_BAR},
    [CollectibleType.COLLECTIBLE_INNER_CHILD] = {CollectibleType.COLLECTIBLE_C_SECTION},
    [CollectibleType.COLLECTIBLE_C_SECTION] = {CollectibleType.COLLECTIBLE_INNER_CHILD},
    [CollectibleType.COLLECTIBLE_MOMS_KEY] = {CollectibleType.COLLECTIBLE_DADS_KEY},
    [CollectibleType.COLLECTIBLE_DADS_KEY] = {CollectibleType.COLLECTIBLE_MOMS_KEY},
    [CollectibleType.COLLECTIBLE_SHARP_KEY] = {CollectibleType.COLLECTIBLE_RED_KEY},
    [CollectibleType.COLLECTIBLE_RED_KEY] = {CollectibleType.COLLECTIBLE_SHARP_KEY},
    [CollectibleType.COLLECTIBLE_GOLDEN_RAZOR] = {CollectibleType.COLLECTIBLE_RAZOR_BLADE},
    [CollectibleType.COLLECTIBLE_RAZOR_BLADE] = {CollectibleType.COLLECTIBLE_GOLDEN_RAZOR},
    [CollectibleType.COLLECTIBLE_BLOODY_LUST] = {CollectibleType.COLLECTIBLE_LUSTY_BLOOD},
    [CollectibleType.COLLECTIBLE_LUSTY_BLOOD] = {CollectibleType.COLLECTIBLE_BLOODY_LUST},
    [CollectibleType.COLLECTIBLE_FRIEND_FINDER] = {CollectibleType.COLLECTIBLE_TWISTED_PAIR},
    [CollectibleType.COLLECTIBLE_TWISTED_PAIR] = {CollectibleType.COLLECTIBLE_FRIEND_FINDER},
    [CollectibleType.COLLECTIBLE_POP] = {CollectibleType.COLLECTIBLE_LACHRYPHAGY},
    [CollectibleType.COLLECTIBLE_LACHRYPHAGY] = {CollectibleType.COLLECTIBLE_POP},
    [CollectibleType.COLLECTIBLE_TECHNOLOGY] = {CollectibleType.COLLECTIBLE_TECH_5},
    [CollectibleType.COLLECTIBLE_TECH_5] = {CollectibleType.COLLECTIBLE_TECHNOLOGY},
    [CollectibleType.COLLECTIBLE_HOLY_LIGHT] = {CollectibleType.COLLECTIBLE_DARK_MATTER},
    [CollectibleType.COLLECTIBLE_DARK_MATTER] = {CollectibleType.COLLECTIBLE_HOLY_LIGHT},
    [CollectibleType.COLLECTIBLE_JACOBS_LADDER] = {CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO},
    [CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO] = {CollectibleType.COLLECTIBLE_JACOBS_LADDER},
    [CollectibleType.COLLECTIBLE_DOLLAR] = {CollectibleType.COLLECTIBLE_3_DOLLAR_BILL},
    [CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = {CollectibleType.COLLECTIBLE_DOLLAR},
    [CollectibleType.COLLECTIBLE_QUARTER] = {CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER},
    [CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = {CollectibleType.COLLECTIBLE_QUARTER},

    -- Syringes
    [CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_GROWTH_HORMONES] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_ROID_RAGE] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_SPEED_BALL] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_SYNTHOIL] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_VIRUS] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_ADRENALINE] = {CollectibleType.COLLECTIBLE_EUTHANASIA},
    [CollectibleType.COLLECTIBLE_EUTHANASIA] = {CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT,
        CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
        CollectibleType.COLLECTIBLE_ROID_RAGE,
        CollectibleType.COLLECTIBLE_SPEED_BALL,
        CollectibleType.COLLECTIBLE_SYNTHOIL,
        CollectibleType.COLLECTIBLE_VIRUS,
        CollectibleType.COLLECTIBLE_ADRENALINE
    },

    -- Fetus in Jar
    [CollectibleType.COLLECTIBLE_DR_FETUS] = {CollectibleType.COLLECTIBLE_ESAU_JR},
    [CollectibleType.COLLECTIBLE_EPIC_FETUS] = {CollectibleType.COLLECTIBLE_ESAU_JR},
    [CollectibleType.COLLECTIBLE_ESAU_JR] = {CollectibleType.COLLECTIBLE_DR_FETUS,
        CollectibleType.COLLECTIBLE_EPIC_FETUS
    },

    -- Blank ...
    [CollectibleType.COLLECTIBLE_BLANK_CARD] = {CollectibleType.COLLECTIBLE_PLACEBO,
        CollectibleType.COLLECTIBLE_CLEAR_RUNE
    },
    [CollectibleType.COLLECTIBLE_PLACEBO] = {CollectibleType.COLLECTIBLE_BLANK_CARD,
        CollectibleType.COLLECTIBLE_CLEAR_RUNE
    },
    [CollectibleType.COLLECTIBLE_CLEAR_RUNE] = {CollectibleType.COLLECTIBLE_BLANK_CARD,
        CollectibleType.COLLECTIBLE_PLACEBO
    },
    
    -- Sacks
    [CollectibleType.COLLECTIBLE_SACK_OF_PENNIES] = {CollectibleType.COLLECTIBLE_BLACK_POWDER},
    [CollectibleType.COLLECTIBLE_BOMB_BAG] = {CollectibleType.COLLECTIBLE_BLACK_POWDER},
    [CollectibleType.COLLECTIBLE_RUNE_BAG] = {CollectibleType.COLLECTIBLE_BLACK_POWDER},
    [CollectibleType.COLLECTIBLE_MYSTERY_SACK] = {CollectibleType.COLLECTIBLE_BLACK_POWDER},
    [CollectibleType.COLLECTIBLE_SACK_OF_SACKS] = {CollectibleType.COLLECTIBLE_BLACK_POWDER},
    [CollectibleType.COLLECTIBLE_BLACK_POWDER] = {CollectibleType.COLLECTIBLE_SACK_OF_PENNIES,
        CollectibleType.COLLECTIBLE_BOMB_BAG,
        CollectibleType.COLLECTIBLE_RUNE_BAG,
        CollectibleType.COLLECTIBLE_MYSTERY_SACK,
        CollectibleType.COLLECTIBLE_SACK_OF_SACKS
    },

    -- Mod Items
    -- ["ZodiacItems"] = "Ophiuchus",
    -- [""] = "",
    -- ["Big Rock"] = "Rock Bottom",
    -- [""] = "",
    -- ["Planetariums"] = "Nebula",
    -- [""] = "",
    -- ["Bell Baby"] = "Blood Puppy",
    -- [""] = "",
    -- ["Treasure Map"] = "Cursed Map",
    -- [""] = "",
    -- ["Blue Map"] = "Cursed Map",
    -- [""] = "",
    -- ["Big Fan"] = "Maurice",
    -- [""] = "",
    -- ["Seraphim"] = "Fallen Angel",
    -- [""] = "",
    -- ["D6"] = "Cursed D6",
    -- [""] = "",
    -- ["The Soul/Mind"] = "The Void",
    -- [""] = "",
    -- ["The Body"] = "Cursed Body",
    -- [""] = "",
    -- ["Calcium"] = "Sulfur",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
    -- [""] = "",
}


local function authorizeCardFlip(card_subtype)
    local isaac_config = Isaac.GetItemConfig()
    local card_config = isaac_config:GetCard(card_subtype)
    local card_achievement = card_config.AchievementID
    if card_achievement == -1 then return true
    else return Isaac.GetPersistentGameData():Unlocked(card_achievement) end
end

local function getPossibleSubtypes(all_subtypes)
    local possible_subtypes = {}

    local isaac_config = Isaac.GetItemConfig()
    for _, subtype in pairs(all_subtypes) do
        local item_config = isaac_config:GetCollectible(subtype)
        local item_achievement = item_config.AchievementID
        if item_achievement == -1 then table.insert(possible_subtypes, subtype)
        elseif Isaac.GetPersistentGameData():Unlocked(item_achievement) then table.insert(possible_subtypes, subtype)
        end
    end
    return possible_subtypes
end

local function authorizeItemFlip(item_subtypes)
    return #getPossibleSubtypes(item_subtypes) > 0
end

local function InitEID(_)
    if EID then
        -- add card icon
        local reverseIcon = Sprite()
        reverseIcon:Load("gfx/eid_cardfronts.anm2", true)
        EID:addIcon("Card"..CARD_ID, "Reverse Card", 0, 9, 9, -2, 1, reverseIcon)

        -- add card descriptions
        EID:addCard(CARD_ID, [[Flips tarot cards in the current room
        #Also flips some items]])
        
        -- set blank card info
        EID:addCardMetadata(CARD_ID, 12, false)

    --- Test Card Description ---
        
        --- the bool function  
        local function AnyPlayerHasReverseCard()
            for i = 0, Game():GetNumPlayers()-1 do
                local p = Game():GetPlayer(i)
                if p:GetCard(0) == CARD_ID or p:GetCard(1) == CARD_ID then
                    --- Check wether or not item is unlocked
                    return true
                end
            end
            return false
        end

        EID:addDescriptionModifier(
            "ReverseCardFlip",

        --- Condition
            function(descObj)
                return AnyPlayerHasReverseCard()
            end,

        --- Callback
            function(descObj)
                if descObj.ObjType == 5 
                and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD then
                    if CARD_FLIPS[descObj.ObjSubType] then
                        local flips_into = CARD_FLIPS[descObj.ObjSubType]
                        if authorizeCardFlip(flips_into) then
                            local cardName = EID:getObjectName(5, PickupVariant.PICKUP_TAROTCARD, flips_into)
                            descObj.Description = descObj.Description ..
                            "#{{Card" .. CARD_ID .. "}} Reverse Card turns this into {{Card" .. flips_into .. "}} {{ColorYellow}}" .. cardName .. "{{ColorWhite}}"
                        end
                    end

                elseif descObj.ObjType == 5 
                and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE then
                    if ITEM_FLIPS[descObj.ObjSubType] then
                        local flips_into = getPossibleSubtypes(ITEM_FLIPS[descObj.ObjSubType])
                        if #flips_into == 1 then
                            local item_id = flips_into[1]
                            local itemConfig = Isaac.GetItemConfig():GetCollectible(item_id)
                            local localizedName = Isaac.GetString("Items", itemConfig.Name)
                            descObj.Description = descObj.Description ..
                            "#{{Card" .. CARD_ID .. "}} Reverse Card turns this into {{Collectible" .. item_id .. "}} {{ColorYellow}}" .. localizedName .."{{ColorWhite}}"
                
                        elseif #flips_into > 1 then
                            descObj.Description = descObj.Description ..
                            "#{{Card" .. CARD_ID .. "}} Reverse Card can turn this into "
                            for i, item_id in pairs(flips_into) do
                                local itemConfig = Isaac.GetItemConfig():GetCollectible(item_id)
                                if i == #flips_into then
                                    descObj.Description = descObj.Description ..
                                    "or {{Collectible" .. item_id .. "}}"
                                else
                                    descObj.Description = descObj.Description ..
                                    "{{Collectible" .. item_id .. "}}, "
                                end
                                
                            end
                        end
                    end
                end

                if descObj.ObjType == 5
                and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE
                and descObj.ObjSubType == CollectibleType.COLLECTIBLE_BELT then

                    descObj.Description = descObj.Description ..
                        "#{{Card" .. Card.CARD_WILD .. "}} Wild Card eats poop"
                end
                return descObj
            end
        )    

    end
end


local function flipRoom(_, cardID, playerWhoUsedItem, useFlags)

     -- Loop over all pickups in the room
    for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do

        -- Check for Card flip
        if (entity.Variant == PickupVariant.PICKUP_TAROTCARD and CARD_FLIPS[entity.SubType]) then
            if authorizeCardFlip(CARD_FLIPS[entity.SubType]) then
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, CARD_FLIPS[entity.SubType], true)
                SFXManager():Play(SoundEffect.SOUND_STATIC)
            end

        -- Check for Item flip
        elseif (entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and ITEM_FLIPS[entity.SubType]) then
            if authorizeItemFlip(ITEM_FLIPS[entity.SubType]) then
                local possible_subtypes = getPossibleSubtypes(ITEM_FLIPS[entity.SubType])
                local selected_subtype = possible_subtypes[ math.random( #possible_subtypes ) ]
                
                entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, selected_subtype, true)
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,entity.Position,Vector.Zero,nil)
                SFXManager():Play(SoundEffect.SOUND_STATIC)
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_USE_CARD, flipRoom, CARD_ID)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, InitEID)
-- Mod:AddCallback(ModCallbacks.MC_HUD_RENDER, onHUDRender)