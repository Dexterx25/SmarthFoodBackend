export class FamilyModel {
  public gender?: string;
  public age!: string;
  public parent?: string;
  public user_id!: string;
  constructor(datas: any) {
    this.gender = datas.gender;
    this.age = datas.age;
    this.parent = datas.parent;
    this.user_id = datas.user_id;
    return { ...this };
  }
}
