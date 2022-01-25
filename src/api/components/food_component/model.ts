export class FoodComponentModel {
  public name!: string;
  public code?: string;
  public gross_weight?: string;
  public useful_weight?: string;
  public net_weight?: string;
  public unit_measure_home?: string;
  public category_food_component_id!: string;
  public age_ranges_id!: string;
  public category_id!: string;
  public image?: string;
  public kalories?: string;
  public skuu!: string;
  public description?: string;
  constructor(datas: any) {
    (this.name = datas.name),
      (this.image = datas.image);
    this.gross_weight = datas.gross_weight;
    this.code = datas.code;
    this.useful_weight = datas.useful_weight;
    this.net_weight = datas.net_weight;
    this.unit_measure_home = datas.unit_measure_home;
    this.skuu = datas.skuu;
    this.category_food_component_id = datas.category_food_component_id
    this.kalories = datas.kalories;
    this.description = datas.description
    return { ...this };
  }
}
