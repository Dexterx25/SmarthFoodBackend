export interface foodsMarketsCreatedDTO{
    id:string;
    user_id:string;
    family_member_id:string;
    date_birtday:string;
    gender:string;
    gender_id:string;
    times_recurral_market:string;
    category_name:string;
    date_init:string;
    components:string;
    date_finish:string;
    food_id:string;
    created_at?:string;
    updated_at?:string;
}

export interface foodsMarketFoodComponentDTO {
    food_component_id:string;
    food_market_id:string;
    user_id:string;
    markets_id:string;
}
export interface food_componentsInterface {
    id:string;
    category_id:string;
    category_food_component_id:string;
    name:string;
    code:string;
    gross_weight:string;
    useful_weight:string;
    net_weight:string;
    unit_measure_home:string;
    age_ranges_id:string;
    gender_id:string;
    skuu:string;
    range_name:string;
    range_init:string;
    range_finish:string;
    category_name:string;
}

export interface dataMembersAgrupedInterface {
    user_id:string;
    family_member_id:string;
    date_birtday:string;
    gender:string;
    gender_id:string;
    times_recurral_market:string;
    date_init:string;
    date_finish:string;
}

export interface marketsToCreateInterface {
    times_recurral_market:string;
    date_init:string;
    date_finish:string;
    user_id: string;
}
export interface marketsCreatedInterface {
    id:string;
    times_recurral_market:string;
    date_init:string;
    date_finish:string;
    created_at:string;
    updated_at:string;
}