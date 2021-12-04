export default class userModel {
  public names: string;
  public surnames: string;
  public full_name: string;
  public prefix_number: string;
  public phone_number: number;
  public email: string;
  public type_user_id: string;
  public avatar?: string;
  public height?: number;
  public date_birtday?:any;
  public weight?: number;

  constructor(datas: any) {
    (this.names = datas.names),
    (this.weight = datas.weight),
    this.height = datas.height,
    (this.date_birtday = new Date(datas.date_birtday)),
      (this.surnames = datas.surnames),
      (this.full_name = `${datas.names} ${
        datas.surnames ? datas.surnames : ''
      }`.trim()),
      (this.prefix_number = datas.prefix_number),
      (this.phone_number = datas.phone_number),
      (this.email = datas.email),
      (this.type_user_id = '1'),
      (this.avatar = datas.avatar);
    return { ...this };
  }
}
