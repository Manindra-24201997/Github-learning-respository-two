Global Class UpdateJobsuiteEchoMediaSettingSchedule implements schedulable{

global void execute(SchedulableContext sc) {
      UpdateJobsuiteEchoMediaSetting.updaterefreshtoken();
   }


}