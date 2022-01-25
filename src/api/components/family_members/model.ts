export interface familyMember {
  gender_id: string;
  date_birtday: string;
  parent: string;
  user_id?: string;
  created_at?: string;
  updated_at?: string;
  id?: string
}

export class FamilyMembersModel {
  public list!: familyMember[]
  constructor(datas: any) {
    this.list = datas.list.reduce((acc:any, item:any) =>{
        if(item){
          const {date_birtday, parent} = item
          acc.push({
            gender_id:item.gender == 'Male' ? 1 : item.gender == 'Female' ? 2 : '', 
            date_birtday,
            parent,
          })
        }
        return acc
    },[]);
    return { ...this };
  }
}
