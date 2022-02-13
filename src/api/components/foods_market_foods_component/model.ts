export class FoodMarketFoodComponentModel {
  public food_component_id!: string;
  public food_market_id!: string;
  constructor(datas: any) {
    (this.food_component_id = datas.food_component_id),
    (this.food_market_id = datas.food_market_id)
    return { ...this };
  }
}
export class FoodMarketFoodComponentReturn {
  public name!: string;
  public amount?: string;
  public picture?: string;
  public description?: string;
  public url?: string;
  public price?: string;
  public kalories?: string;
  public category_id!: string;
  constructor(datas: any) {
    (this.name = datas.name),
      (this.amount = datas.amount)((this.picture = datas.picture))(
        (this.description = datas.description)
      );
    this.url = datas.url;
    this.category_id = datas.category_id;
    this.price = datas.price
    this.kalories = datas.kalories
    return { ...this };
  }
}
export enum CateoryFoodEnum {
  dinner = "4",
  breakfast = "1",
  lunch = "2",
  snack = "3"
}
