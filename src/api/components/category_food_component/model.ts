export class CategoryFoodComponent {
  public name?: string;
  public image?: string;

  constructor(datas: any) {
    this.name = datas.name;
    this.image = datas.image;
  }
}
