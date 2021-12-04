export class FoodMarket {
 public name!: string;
 public user_id!: string;
 public total_amount!: string;
 public picture!: string;
 public total_kalories!: string;
 public markets!: string;
 public days_market!: string;
 public date_time_init!: string;
 public date_time_finish!: string;
  constructor(datas: any) {
   this.name = datas.name;
   this.user_id = datas.user_id;
   this.total_amount = datas.total_amount;
   this.picture = datas.picture;
   this.total_kalories = datas.total_kalories;
   this.markets = datas.markets;
   this.days_market = datas.days_market;
   this.date_time_init = datas.date_time_init;
   this.date_time_finish = datas.date_time_finish;
    return { ...this };
  }
}
