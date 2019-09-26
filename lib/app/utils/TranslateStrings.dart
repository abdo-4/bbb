import 'package:flutter/material.dart';
class TranslateStrings{


static String local = 'ar';

static Map homeTapItems = {
    "map" : 'الخريطة',
    "student" : 'الطلاب',
    "notification" : 'الإشعارات',
    "compliant" : 'الشكاوى',
    "schedule" : 'التقويم',
    //"schoolIDKey" : 'School_ID',    
  };

static void toggle_Local(String locale){
  //if(local == 'ar') local = 'en';
  //else local = 'ar';
  local = locale;
}

static String current_Local_Text(){
  if(local == 'ar') return 'Change to English Interface';
  else return 'التحول الى الواجهة العربية';
}

static TextDirection getTextDirection(){
   if(local == 'ar') return TextDirection.rtl;
  else return TextDirection.ltr;
}

static String getHomeTabItem(String tapItem){
  if(local == 'ar') return homeTapItems[tapItem];
  else return tapItem;
}

static String school_Bus() {
  return local == 'ar'? 'تطبيق سالم' : 'Saleem App';
}

static String bus() {
  return local == 'ar'? 'السيارة' : 'Bus';
}

static String login() {
  return local == 'ar'? 'تسجيل دخول' : 'Login';
}

static String logOut() {
  return local == 'ar'? 'تسجيل خروج' : 'LogOut';
}

static String parentRegisterStudent() {
  return local == 'ar'? 'تسجيل طالب' : 'Student Register';
}

static String something_went_wrong(){
  return local == 'ar'? 'حدث خطأ':'Something went wrong!';
}  

static String school_Schedule_Null(){
  return local == 'ar'? 'لاتوجد بيانات للتقويم المدرسي!':'School Schedule is null!';
}

static String empty(){
  return local == 'ar'? 'لاتوجد بيانات':'Empty!';
}

static String saveDone(){
  return local == 'ar' ? 'تم الحفظ'  : 'Save Done';
}

static String networkError(){
  return local == 'ar'? 'خطأ في الاتصال بالانترنت':'Network Error!';
} 

static String server_Invalid_Data(){
  return local == 'ar'? 'بيانات غير صحيحة':'Server Invalid Data';
} 

static String tripFromHomeToSchool_isNull(){
  return local == 'ar'? 'إختار اتجاه الرحلة':'Select Trip Direction';
}

static String today_Schedule_Trip(){
  return local == 'ar'? 'رحلة اليوم':'Today Schedule Trip';
}

static String there_is_no_Schedule_Trip_Today_Select_New_Trip(){
  return local == 'ar'? 'لاتوجد رحلة خلال اليوم... إختار بدأ رحلة':'There is no Schedule Trip Today... Select New Trip';
}

static String check_Connection(){ 
  return local == 'ar'? ' تحقق من الاتصال... ': " Check Connection... ";
} 

static String unauthorized_User(){ 
  return local == 'ar'? 'المستخدم ليس لديه صلاحية!': "Unauthorized User!";
} 

static String start_New_Trip(){ 
  return local == 'ar'? 'بدأ رحلة جديدة': 'Start New Trip';
}

static String start_Trip(){ 
  return local == 'ar'? 'بدأ الرحلة': 'Start Trip';
} 

static String finish_Trip(){ 
  return local == 'ar'? 'إنهاء الرحلة': "Finish Trip";
}

static String current_Trip(){ 
  return local == 'ar'? 'رحلة نشطة': 'Current Trip';
}  

static String select_Trip_Direction_from_below(){ 
  return local == 'ar'? 'إختار إتجاه الرحلة من القائمة' : 'Select Trip Direction from below:';
}

static String go_to_School(){ 
  return local == 'ar'? 'رحلة الى المدرسة' : 'Go to School';
}

static String back_to_home(){ 
  return local == 'ar'? 'رحلة الى المنزل': 'Back to Home';
}

static String trip(){ 
  return local == 'ar'? 'الرحلة': "Trip";
}

static String trip_Note(){ 
  return local == 'ar'? 'إشعار الرحلة': "Trip Note";
}

static String school(){ 
  return local == 'ar'? 'المدرسة': "School";
}

static String branch(){ 
  return local == 'ar'? 'الفرع': "Branch";
}

static String driver(){ 
  return local == 'ar'? 'السائق': "Driver";
} 

static String trip_Finished(){ 
  return local == 'ar'? 'الرحلة انتهت': "Trip Finished";
} 

static String tripToSchool(){ 
  return local == 'ar'? 'رحلة المدرسة': "Trip to School";
}

static String tripToHome(){ 
  return local == 'ar'? 'رحلة العودة للمنزل': "Trip Back to Home";
}

static String invalid_username_Password(){
  return local == 'ar'? 'اسم المستخدم أو كلمة المرور خطأ':'Invalid username/Password';
} 

static String password_cant_be_blank(){
  return local == 'ar'? 'كلمة المرور ليست فارغة':"Password can't be blank!";
} 

static String username_cant_be_blank(){
  return local == 'ar'? 'اسم المستخدم ليس فارغاً':"username can't be blank!";
} 

static String password_Length_is_invalid(){
  return local == 'ar'? 'عدد الحروف اقل من اللازم':"Password Length is invalid!";
} 

static String student_ID(){
  return local == 'ar'? 'رقم الطالب':"Student ID";
} 

static String user_Name(){
  return local == 'ar'? 'اسم المستخدم':"User Name";
} 

static String birth_Date(){
  return local == 'ar'? 'تاريخ ميلاد الطالب':"Birth Date";
} 

static String password(){
  return local == 'ar'? 'كلمة المرور':"Password";
}  

static String home(){
  return local == 'ar'? 'الصفحة الرئيسية':"Home";
} 

static String start_Trip_running_trip(){
  return local == 'ar'? 'بدأ رحلة/الرحلة النشطة':"Start Trip/running trip";
} 

static String emergency_Contacts(){
  return local == 'ar'? 'ارقام هواتف الطوارئ':"Emergency Contacts";
} 

static String change_Password(){
  return local == 'ar'? 'تغيير كلمة المرور':"Change Password";
} 

static String new_Password_Not_Match(){
  return local == 'ar'? 'كلمة المرور ليست متطابقة!':"New Password Not Match!";
} 

static String current_Password(){
  return local == 'ar'? 'كلمة المرور الحالية':"Current Password";
} 

static String new_Password(){
  return local == 'ar'? 'كلمة المرور الجديدة':"New Password";
} 

static String confirm_Password(){
  return local == 'ar'? 'تأكيد كلمة المرور':"Confirm Password";
} 


static String drawer_School(){
  return local == 'ar'? 'المدرسة':"School";
}

static String drawer_Phone(){
  return local == 'ar'? 'تلفون المدرسة':"School Phone";
}

static String drawer_Manager(){
  return local == 'ar'? 'المدير':"Manager";
}
static String drawer_ManagerContact(){
  return local == 'ar'? 'رقم المدير':"Manager Contact";
}
static String drawer_Description(){
  return local == 'ar'? 'التعريف بالمدرسة':"School Description";
}

static String noData(){
  return local == 'ar'? 'لاتوجد بيانات':"No Data";
}

static String updateAppVersion(){
  return local == 'ar'? 'حدث التطبيق':'Update App Version';
}

static String add_Student(){
  return local == 'ar'? 'إضافة طالب':'Add Student';
}  

static String busDistanceLeft(){
  return local == 'ar'? 'تبقى لوصول الحافلة حوالي: ':'Bus about : ';
}

//TODO: Add symbol to message.
static String nullStudent(){
  return local == 'ar'? 'لايوجد بيانات طلاب!':'No Students List!';
}

static String student(){
  return local == 'ar'? 'الطالب':'Student';
}

static String parent(){
  return local == 'ar'? 'الآباء':'Parent';
}

static String no_Contact_Number(){
  return local == 'ar'? 'لايوجد رقم تلفون':"No Contact Number!";
}

static String confirm_Dialog(){
  return local == 'ar'? 'تأكيد':"Confirm";
}

static String confirm_Dialog_StudentPickupChange(){
  return local == 'ar'? 'تغيير الموقع، هل متأكد':"Confirm Pickup Change";
}

static String add_Absent(){
  return local == 'ar'? 'إضافة غياب':'Add Absent';
}

static String remove_Absent(){
  return local == 'ar'? 'إزالة الغياب':'Remove Absent';
}

static String absent(){
  return local == 'ar'? 'الغياب':'Absent';
}

static String send_Msg_To(){
  return local == 'ar'? ' إرسال رسالة الى ':"Send Msg To ";
}

static String to_School_Branch(){
  return local == 'ar'? ' إرسال رسالة الى ':"Send Msg To ";
}

static String to_School(){
  return local == 'ar'? ' إرسال رسالة الى ':"Send Msg To ";
}

static String to_Supervisor(){
  return local == 'ar'? 'إرسال رسالة الى المشرف ':"Send Msg To Supervisor";
} 

static String to_Driver(){
  return local == 'ar'? ' إرسال رسالة الى السائق ':"Send Msg To Driver";
} 

static String sendMsgTo(){
  return local == 'ar'? ' إرسال رسالة الى ':"Send Msg To ";
} 

static String no_Notification_List(){
  return local == 'ar'? 'لاتوجد اشعارات!':"No Notification!";
}

static String no_Compliant_List(){
  return local == 'ar'? 'لاتوجد شكاوي!':"No Compliant!";
}

static String no_Student_List(){
  return local == 'ar'? 'لايوجد طلاب!':"No Students!";
}

static String date_Time(){
  return local == 'ar'? 'التاريخ':"Date Time";
} 

static String date(){
  return local == 'ar'? 'التاريخ':"Date";
}

static String notes(){
  return local == 'ar'? 'إشعار':"Notes";
}

static String msg_To(){
  return local == 'ar'? 'الى':"To";
}

static String send(){
  return local == 'ar'? 'ارسال':"Send";
}

static String cancel(){
  return local == 'ar'? 'إلغاء':"Cancel";
}

static String yes(){
  return local == 'ar'? 'موافق':"Yes";
}

static String continue_(){
  return local == 'ar'? 'مواصلة':"Continue";
}

static String msg_From(){
  return local == 'ar'? 'من':"From";
}

static String map_student_id(){
  return local == 'ar'? 'رقم الطالب':"student_id_";
}

static String map_StudentName_Null(){
  return local == 'ar'? 'لايوجد طالب':"Name: null";
}

static String map_Grade_Null(){
  return local == 'ar'? 'لايوجد مستوى':"Grade: null";
} 

static String map_Parent_Null(){
  return local == 'ar'? 'لايوجد والد':"Parent: null";
}

static String subject(){
  return local == 'ar'? 'العنوان':"Subject";
}

static String type_Message(){
  return local == 'ar'? 'أكتب رسالة':"Type Message";
}

static String msg(){
  return local == 'ar'? 'رسالة':"Msg";
}

static String sender(){
  return local == 'ar'? 'الراسل':"Sender";
}

static String replay_To(){
  return local == 'ar'? 'الرد الى ':"Replay To ";
}

static String wait_msg(){ 
  return local == 'ar'? 'انتظر...': 'Wait...';
}

static String name(){ 
  return local == 'ar'? 'الاسم': 'Name';
}

static String contact(){ 
  return local == 'ar'? 'التلفون': 'Contact';
}

static String address(){ 
  return local == 'ar'? 'العنوان': 'Address';
} 

static String email(){ 
  return local == 'ar'? 'البريد': 'Email';
} 

static String rating(){ 
  return local == 'ar'? 'التقدير': 'Rating';
}

static String supervisor(){ 
  return local == 'ar'? 'المشرف': 'Supervisor';
}

}