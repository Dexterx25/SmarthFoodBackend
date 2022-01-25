
interface FoodModelCreated{
  food_id:string;
}
interface FamilyMemberModelCreated{
  family_member_id:string;
}
export class Markets {
  public foodsListId: [FoodModelCreated]
  public user_id: string;
  public listFamily_member_id: [FamilyMemberModelCreated];
  public days_market: string;
  public date_init?: string;
  public date_finish?: string;
  constructor(datas: any) {
   this.foodsListId = datas.foodsListId;
   this.user_id = datas.user_id;
   this.listFamily_member_id = datas.listFamily_member_id;
   this.days_market = datas.days_market;
   this.date_init = datas.date_init;
   this.date_finish = datas.date_finish;
    return { ...this };
  }
}
