<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AirplaneTypes.aspx.cs" Inherits="AirplaneTypes" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
  <script type="text/javascript">
$(document).ready(function(){

addhandlers();

$("#addairplanetypeform").submit(function(){
 var valid=true;
 $('.errortext').remove();
  $('.error').removeClass('error');
$("input.required:enabled").each(function(i){
      if($(this).val()=="")
      {
       valid=false;
       $("<div class='errortext'>* Required.</div>").insertAfter($(this).addClass('error'));
      }
       

});
$("input.number:enabled").each(function(i){
      if(isNaN($(this).val()))
      {
       valid=false;
       $("<div class='errortext'>* Number Required.</div>").insertAfter($(this).addClass('error'));
       }
       

});
if(valid)
       {
           $.ajax({
                'url': 'UpdateAirplanetypes.ashx',
                'data': $("#addairplanetypeform").serialize(),
                'dataType': 'json',
                'type': 'POST',
                'beforeSend':function(){
                
                  $("#Status").html("<img src='../images/loadingAnimation.gif' />");
                  
                },
                'success': function(data) {
                  if(data['error'])
                  {
                   $("#Status").html(data['text']);
                   return;
                  }
                    var resp="";
                    resp+="<tr><td>"+data['airplanetype'].PlaneTypeID+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].PlaneTypeName+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].InitialDistance+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].MiddleDistance+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].InitialSpeed+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].MiddleSpeed+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].MaximumSpeed+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].Capacity+"</td>";
                    resp+="<td class='edit'>"+data['airplanetype'].ParentCategory+"</td>";
                    resp+="<td>";
                    resp+="<div style='margin-bottom:5px'>";
                    resp+="<a href='ShowAircraftTypePhoto.aspx?atypeid="+data['airplanetype'].PlaneTypeID+"&keepThis=true&TB_iframe=true&height=500&width=400' class='thickbox' title='"+data['airplanetype'].PlaneTypeName+"'>Photo</a>";
                    resp+="</div>";
                    resp+="<a href='#' class='remove small-link'>Remove</a></td>";
                    resp+="</tr>";
                    
                    $("#planetypelist").append(resp);
                    addhandlers();
                     tb_init($(resp).find("a.thickbox"));
                    $("#Status").html(data['text']);
                    
                  
                  
                }
                });
         }
return false;
});

});
var addhandlers=function(){
$('.edit').editable("UpdateAirplanetypes.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
         var i=$(this).parents("tr:eq(0)").find("td").index(this);
         var head=jQuery.trim($("#planetypelist th:eq("+i+")").text());
        return {atypeid: jQuery.trim($(this).parents("tr:eq(0)").find("td:first").text()),property:head,updateairplanetype:'1'};
      
         },
         onsubmit:function(settings, original){
          if($(this).parents("td").hasClass("required"))
          {
             if($(this).find("input[type=text]").val()=="")
             {
              alert("Field Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
          if($(this).parents("td").hasClass("number"))
          {
            if(isNaN($(this).find("input[type=text]").val()))
             {
                alert("Number Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }
          }
          },
         style   : 'display: inline'
     });

$(".remove").click(function(){
var currelem=$(this);
if(confirm("Are you sure?"))
{
  var id=jQuery.trim($(this).parents("tr:eq(0)").find("td:first").text());
 
  $.ajax({
                'url': 'UpdateAirplanetypes.ashx',
                'data': 'removetype=1&atypeid='+id,
                'dataType': 'json',
                'type': 'POST',
                'success': function(data) {
                  
                  if(data['success'])
                  {
                   currelem.parents("tr:eq(0)").remove();
                  }
                  
                  alert(data['text']);
                }
                });
}
return false;
});

}
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <table class="bluetable" id="planetypelist" style="margin-top:20px">
        <tr>
            <th>
                Plane Type ID</th>
            <th>
                Plane Type Name</th>
            <th>
                Initial Distance</th>
            <th>
                Middle Distance</th>
            <th>
                Initial Speed</th>
            <th>
                Middle Speed</th>
            <th>
                Maximum Speed</th>
            <th>
                Capacity</th>
            <th>
                Parent Category</th>
            <th>
            </th>
        </tr>
        <% IList<AirplaneType> atypes = OperatorDAO.GetAirplaneTypes(); %>
        <% 
    
            foreach (AirplaneType a in atypes)
           {
        %>
        <tr>
            <td>
                <%= a.PlaneTypeID %>
            </td>
            <td class="edit required">
                <%= a.PlaneTypeName %>
            </td>
            <td class="edit required number">
                <%= a.InitialDistance %>
            </td>
            <td class="edit required number">
                <%= a.MiddleDistance %>
            </td>
            <td class="edit required number">
                <%= a.InitialSpeed %>
            </td>
            <td class="edit required number">
                <%= a.MiddleSpeed %>
            </td>
            <td class="edit required number">
                <%= a.MaximumSpeed %>
            </td>
            <td class="edit required">
                <%= a.Capacity %>
            </td>
            <td class="edit required">
                <%= a.ParentCategory%>
            </td>
            <td>
            <div style="margin-bottom:5px">
            <a href="ShowAircraftTypePhoto.aspx?atypeid=<%= a.PlaneTypeID %>&keepThis=true&TB_iframe=true&height=500&width=400" class="thickbox" title="<%= a.PlaneTypeName %>">Photo</a>
            </div>
                <a href="#" class="remove small-link">Remove</a></td>
        </tr>
        <%
         
            } %>
    </table>
    <form id="addairplanetypeform">
        <table class="bluetable" style="width:500px;margin-left:auto;margin-right:auto;margin-top:20px">
            <tr>
                <th>
                    Plane Type ID</th>
                <td>
                    <input type="text" name="planetypeid" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Plane Type Name</th>
                <td>
                    <input type="text" name="planetypename" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Initial Distance</th>
                <td>
                    <input type="text" name="initialdistance" class="required number" />
                </td>
            </tr>
            <tr>
                <th>
                    Middle Distance</th>
                <td>
                    <input type="text" name="middledistance" class="required number" />
                </td>
            </tr>
            <tr>
                <th>
                    Innitial Speed</th>
                <td>
                    <input type="text" name="initialspeed" class="required number" />
                </td>
            </tr>
            <tr>
                <th>
                    Middle Speed</th>
                <td>
                    <input type="text" name="middlespeed" class="required number" />
                </td>
            </tr>
            <tr>
                <th>
                    Maximum Speed</th>
                <td>
                    <input type="text" name="maximumspeed" class="required number" />
                </td>
            </tr>
            <tr>
                <th>
                    Capacity</th>
                <td>
                    <input type="text" name="capacity" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Parent Category</th>
                <td>
                    <select name="parentcategory">
                        <option>Helicopter</option>
                        <option>Jet</option>
                        <option>Turboprop</option>
                        <option>Airliner</option>
                    </select>
                    <input type="hidden" name="formaddairplanetypebtn" />
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" class="buttons" value="Add" name="addairplanetypebtn" />
                    <div id="Status">
                    </div>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
