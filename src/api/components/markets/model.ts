export class FoodModel {
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
export class FoodModelReturn {
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

export interface CategoryFoods {
    filter: string
}