export class PollModel {
  public times_recurral_market!: string;
  public count_persons?: string;
  public sugest_snaks?: boolean;
  public user_id?: string;
  public sugest_without_dairy?: boolean;
  public vegetarian_food?: boolean;
  public type_id?:string;
  constructor(datas: any) {
    this.times_recurral_market = datas.times_recurral_market;
    this.count_persons = datas.count_persons;
    this.sugest_snaks = datas.sugest_snaks;
    this.user_id = datas.user_id;
    this.sugest_without_dairy = datas.sugest_without_dairy;
    this.vegetarian_food = datas.vegetarian_food;
    this.type_id = datas.type_id ? datas.type_id : '1'; 
    return { ...this };
  }
}
