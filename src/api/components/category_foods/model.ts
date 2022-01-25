export class CategoryFood {
  public category_name?: string;
  public picture?: string;

  constructor(datas: any) {
    this.category_name = datas.category_name;
    this.picture = datas.picture;
  }
}
