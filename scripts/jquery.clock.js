/**
 * @author Terry Wooton
 * @desc transforms a text input box into a dropdown style analog clock
 * @version 1.1
 * @example
 * $("#element").clock({displayFormat:'12',defaultHour:'12',defaultMinute:'00',defaultAM:'AM',seconds:false});
 * @license free
 *
 */
 
$(document).ready(function() {
  var clockNumber = 0;
  $.fn.clock = function(params) {
    
    $(this).each(function() {
      var s = $(this).extend({displayFormat:12,defaultHour:'12',defaultMinute:'00',defaultAM:'AM',seconds:false,defaultSeconds:'00'},params || {});
      var clockTemplate  = '<div id="clock'+ (++clockNumber) +'">';
      clockTemplate += '<select name="clockHours'+clockNumber+'" id="clockHours'+clockNumber+'" rel="'+clockNumber+'">';
      for(var i = 1; i<=s.displayFormat;i++){
        j = (i<10 ? ('0'+i) : i);
        clockTemplate += '<option value="'+j+'"'+(j == s.defaultHour ? ' selected' : '')+'>'+j+'</option>';
      }
      clockTemplate += '</select>';        
      clockTemplate += ':<select name="clockMinutes'+clockNumber+'" id="clockMinutes'+clockNumber+'" rel="'+clockNumber+'">';
      for(var i = 0; i<60;i+=15){
        j = (i<10 ? ('0'+i) : i);
        clockTemplate += '<option value="'+j+'"'+(j == s.defaultMinute ? ' selected' : '')+'>'+j+'</option>';
      }      
      clockTemplate += '</select>';
      if(s.seconds){
        clockTemplate += ':<select name="clockSeconds'+clockNumber+'" id="clockSeconds'+clockNumber+'" rel="'+clockNumber+'">';
        for(var i = 0; i<60;i++){
          j = (i<10 ? ('0'+i) : i);
          clockTemplate += '<option value="'+j+'"'+(j == s.defaultSeconds ? ' selected' : '')+'>'+j+'</option>';
        }                    
        clockTemplate += '</select>';
      }
      if(s.displayFormat == '12'){
        clockTemplate += '&nbsp;<select name="clockAM'+clockNumber+'" id="clockAM'+clockNumber+'" rel="'+clockNumber+'">';
        clockTemplate += '<option value="AM"'+(s.defaultAM == 'AM' ? ' selected' : '')+'>AM</option>';
        clockTemplate += '<option value="PM"'+(s.defaultAM == 'PM' ? ' selected' : '')+'>PM</option>';
        clockTemplate += '</select>';
      }
      clockTemplate += '</div>';            
      var t = $(this);          
      $(this).css({display:'none'});
      $(this).after(clockTemplate);
      calculateClockValue(t,s,clockNumber);
      $('#clockHours'+clockNumber+', #clockMinutes'+clockNumber+', #clockSeconds'+clockNumber+', #clockAM'+clockNumber).change(function(from){
        var num = $(this).attr('rel');
        calculateClockValue(t,s,num);
      });
    });
    
    function calculateClockValue(t,s,num){
      var hour = $('#clockHours'+num).val();
      var minutes = ':'+$('#clockMinutes'+num).val();
      var sec = (s.seconds ? ':'+$('#clockSeconds'+num).val() : '');
      var am = (s.displayFormat == '12' ? ' ' + $('#clockAM'+num).val() : '');                    
      t.val(hour + minutes + sec + am);    
    }
  }      
});