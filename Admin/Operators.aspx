<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Operators.aspx.cs" Inherits="Operators" Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">
    <style type="text/css">
    select
    {
     width:100px;
    }
    </style>

    <script type="text/javascript">
$(document).ready(function(){
addcountrynames();

$.editable.addInputType('countries', {
    element : function(settings, original) {
        var input = $('select[name=country]').clone();
        input.find("option[value=all]").remove();
        $(this).append(input);
        return(input);
    }
});
$('.editcountries').editable("UpdateOperators.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          var head=jQuery.trim($("#oplist th:eq("+i+") span").text());
          return {opid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateoperator:'1'};
      
         },
         type:'countries',
         style   : 'display: inline;',
         callback:function(){
         
         addcountrynames($(this).parents("tr:eq(0)")) ;
         
         }
     });
$('.edit').editable("UpdateOperators.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var i=$(this).parents("tr:eq(0)").children("td").index(this);
          
          var head=jQuery.trim($("#oplist th:eq("+i+") span").text());
          
          return {opid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateoperator:'1'};
      
         },
         style   : 'display: inline',
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
         if($(this).parents("td").hasClass("email"))
          {
             var temp=true;
             if($(this).find("input[type=text]").val()=="")
                temp=false;
              
            if(!echeck($(this).find("input[type=text]").val()) && temp)
            {
              alert("Invalid Email.");
              original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
               
         }
     });
     $('.editp').editable("UpdateOperators.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          
          return {opid: jQuery.trim($(this).parents("tr.operatorrow:eq(0)").find("td input[type=hidden]").val()),property:head,updateoperator:'1'};
      
         },
         style   : 'display: inline',
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
         if($(this).parents("td").hasClass("email"))
          {
             var temp=true;
             if($(this).find("input[type=text]").val()=="")
                temp=false;
              
            if(!echeck($(this).find("input[type=text]").val()) && temp)
            {
              alert("Invalid Email.");
              original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
               
         }
     });
     $('.edittext').editable("UpdateOperators.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         type:'autogrow',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
          var head=jQuery.trim($(this).parents("tr:eq(0)").find("th span").text());
          
          return {opid: jQuery.trim($(this).parents("tr.operatorrow:eq(0)").find("td input[type=hidden]").val()),property:head,updateoperator:'1'};
      
         },
         style   : 'display: inline',
         autogrow : {
           lineHeight : 16,
           minHeight  : 32
        }
     });
  
 $('.editselect').editable("UpdateOperators.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'1':'Confirm','0':'Pending'}",
         submitdata : function(value, settings) {
         
          var i=$(this).parents("tr:eq(0)").children("td").index(this);

          var head=jQuery.trim($("#oplist th:eq("+i+") span").text());
          
          return {opid: jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val()),property:head,updateoperator:'1'};
         },
         callback:function(){
           
           if($(this).text()=="1")
           {
            $(this).text("Confirm");
           }else if($(this).text()=="0")
           {
            $(this).text("Pending");
           }
         
         }
         ,
         style   : 'display: inline;'
     });
$("#opcountriesform").submit(function(){
   
  var form=$(this);
  $.ajax({
            'url': 'UpdateOperators.ashx',
            'data': $(this).serialize()+"&opcountriessave=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#Status").html("<img src='../images/loadingAnimation.gif' />");
              
            },
            'success': function(data) {
            
               $("#Status").html(data['saved']);
               
               $("#opcountriesdiv"+$("#opcountriesform").find("input[name=opid]").val()).html(data['clist']);
               
                
            }
            });
 return false;

});  
$("a.sendpass").click(function(){
 
 var url=$(this);
 $(url).siblings("span.passstatus").remove();
 $.ajax({
            'url': url.attr("href"),
            'dataType': 'text',
            'beforeSend':function(){
             
             $(url).siblings("span.passstatus").remove();
             $("<span class='passstatus'>Sending</span>").insertAfter(url); 
              
            },
            'success': function(data) {
            
              $(url).siblings("span.passstatus").remove();
               
               $("<span class='passstatus'>Sent.</span>").insertAfter(url); 
               
                
            }
            });
            return false;



});   
$("select[name=operatorcountries]").change(function(){
      
        $("input[class=continents]").each(function(i){
                  
          var expsize= $("select[name=operatorcountries]").children("option[cont="+$(this).val()+"]").size(); 
          var actsize= $("select[name=operatorcountries]").children("option[cont="+$(this).val()+"]:selected").size(); 
           
          if(expsize>actsize)
           $(this).removeAttr("checked");
          else
            $(this).attr("checked","checked");
        });
      
      });
     
     
$("input[class=continents]").click(function(){
     
 if($(this).is(":checked"))
  {
     $("select[name=operatorcountries]").children("option[cont="+$(this).val()+"]").attr('selected','selected');
  }
  else
  {
    $("select[name=operatorcountries]").children("option[cont="+$(this).val()+"]").removeAttr('selected');
  }
});
 
 $(".editoperatorcountries").click(function(){
 
   var cids=jQuery.trim($(this).siblings("div:eq(0)").text());
   var opid=jQuery.trim($(this).parents("tr:eq(0)").find("td input[type=hidden]").val());
  $("select[name=operatorcountries] option").removeAttr("selected");
   $.each(cids.split(","),function(li,l){
   
     $("select[name=operatorcountries] option[value="+l+"]").attr("selected","selected");
    
   });
   tb_show("Operator Countries","#TB_inline?width=450&height=300&inlineId=modalWindow");
   $("#opcountriesform input[name=opid]").val(opid);
    $("select[name=operatorcountries]").change();
   
    return false;
 });
 $(".remove").click(function(){
 if(confirm("Are you sure?"))
    return true;
 else
    return false;  
 
 });

     
});
var addcountrynames=function(row){

var countryhead=$("#oplist th:contains('Country')");

var i=$("#oplist tr:eq(0) th").index(countryhead);
if(row)
{
  var temp=row.find("td.editcountries");
var cid= jQuery.trim(temp.text());
if(cid!="")
 temp.text($("select[name=country] option[value="+cid+"]").text());
 
}else
{

$("#oplist td.editcountries").each(function(index){

var cid= jQuery.trim($(this).text());
if(cid!="")
 $(this).text($("select[name=country] option[value="+cid+"]").text());
 
});
}


}
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <% 
        Int32 pageid = 1;
        if (Request.Params.Get("pageid") != null)
        {
            pageid = Int32.Parse(Request.Params.Get("pageid"));
        }
        NameValueCollection pars = Request.QueryString;
        IList<Operator> opfulllist = OperatorDAO.GetOperators(Request.QueryString);
        IList<Operator> oplist = OperatorDAO.GetOperators(pageid, 15, Request.QueryString);
    %>
    <form id="opsearchform" action="operators.aspx">
        <table class="bluetable" style="width: 900px; margin-left: auto; margin-right: auto;
            margin-top: 20px">
            <tr>
                <th>
                    <span>Login Email</span><br />
                    <input type="text" name="email" value="<%= pars["email"] %>" />
                </th>
                <th>
                    <span>Company Name</span><br />
                    <input type="text" name="opname" value="<%= pars["opname"] %>" />
                </th>
                <th>
                    <span>Certificate</span><br />
                    <input type="text" name="nsopregno" value="<%= pars["nsopregno"] %>" />
                </th>
                <th>
                    <span>Select Country: </span>
                    <br />
                    <select name="country">
                        <option value="all" <%= (pars["country"]!=null)?"":"selected" %>>All</option>
                        <%  foreach (Country c in OperatorDAO.GetCountries())
                            {
                                String cid = c.CountryID;
                        %>
                        <option cont="<%= c.Continent %>" value="<%= cid %>" <%= (pars["country"]==cid)?"selected" :"" %>>
                            <%= c.FullName%>
                        </option>
                        <%
               
                            } %>
                    </select>
                </th>
                <th>
                    <span>Status: </span>
                    <br />
                    <select name="status">
                        <option value="confirm" <%= (pars["status"]=="confirm")?"selected":"" %>>Confirm</option>
                        <option value="pending" <%= (pars["status"]=="pending")?"selected":"" %>>Pending</option>
                    </select>
                </th>
                <th>
                    <br />
                    <input type="submit" class="buttons" name="opsearchbtn" value="search" />
                </th>
            </tr>
        </table>
    </form>
    <br />
    <span class="brown">Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(opfulllist.Count / 15.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"Operators.aspx", i) %>" style="margin-right: 5px">
            <%= i %>
        </a>
        <%
            }
            else
            {
        %>
        <span style="margin-right: 5px">
            <%= i %>
        </span>
        <%
            }
        }
           
        %>
    </span>
    <br />
    <table class="bluetable" style="margin-top: 10px; width: 970px" id="oplist">
        <tr>
            <th style="display: none">
            </th>
            <th>
                Personal Details</th>
            <th>
                <span style="display: none">CompanyName</span> Company Name</th>
            <th>
                <span style="display: none">NSOPRegNo</span> Certificate</th>
            <th>
                <span style="display: none">Country</span> Country</th>
            <th>
                <span style="display: none">OperatorShortName</span> Operator Short Name</th>
            <th>
                Operator Countries</th>
            <th>
                <span style="display: none">Status</span>Status</th>
            <th>
            </th>
        </tr>
        <% foreach (Operator op in oplist)
           {
        %>
        <tr class="operatorrow">
            <td style="display: none">
                <input type="hidden" value="<%= op.OperatorId %>" name="opid" /></td>
            <td>
                <table class="noborder">
                    <tr>
                        <th>
                            Email<span style="display: none">Email</span></th>
                        <td class="editp required email">
                            <%= op.Email  %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Alternate<span style="display: none">Email1</span></th>
                        <td class="editp email">
                            <%= op.Email1  %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Address<span style="display: none">Address</span></th>
                        <td class="edittext" style="width: 200px;">
                            <%= op.Address  %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Contact No<span style="display: none">ContactNo</span></th>
                        <td class="editp required">
                            <%= op.ContactNo  %>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            Alternate Contact<span style="display: none">ContactNo1</span></th>
                        <td class="editp">
                            <%= op.ContactNo1  %>
                        </td>
                    </tr>
                </table>
            </td>
            <td class="edit required">
                <%= op.CompanyName  %>
            </td>
            <td class="edit required">
                <%= op.NSOPRegNo  %>
            </td>
            <td class="editcountries">
                <%= op.Country %>
            </td>
            <td class="edit">
                <%= op.OperatorShortName  %>
            </td>
            <td>
                <div style="display: none" id="opcountriesdiv<%= op.OperatorId %>">
                    <% foreach (String s in op.OperatorCountries)
                       {
                           Response.Write(s + ",");
                       } %>
                </div>
                <a href="#" class="editoperatorcountries">Show</a>
                
            </td>
            <td class="editselect">
                <%= (op.Status==0)?"Pending":"Confirm" %>
            </td>
            <td>
                <a href="aircrafts.aspx?oid=<%= op.OperatorId %>" target="_blank" title="Aircrafts">
                    Aircrafts</a><br />
                <br />
                <a href="EmptyLegEdit.aspx?oid=<%= op.OperatorId %>" target="_blank" title="Empty Legs">
                    Empty Legs</a><br />
                <br />
                <a href="FixedPriceCharterEdit.aspx?oid=<%= op.OperatorId %>" target="_blank" title="FixedPrice Charters">
                   Fixed Price Charters</a><br />
                <br />
                <a href="UpdateOperators.ashx?opid=<%= op.OperatorId %>&sendgeneratepass=1" class="sendpass">
                    Generate and Send Password</a><br />
                <br />
                <a href="UpdateOperators.ashx?opid=<%= op.OperatorId %>&operatorremove=1" class="remove small-link">
                    Remove</a></td>
        </tr>
        <%
            } %>
    </table>
    <div id="modalWindow" style="display: none">
        <form id="opcountriesform">
            <div style="float: left">
                <%
                    foreach (String s in AdminDAO.GetContinents())
                    { 
                %>
                <div>
                    <input type="checkbox" class="continents" value="<%= s %>" /><%= s %></div>
                <%
                     
                    }
                %>
            </div>
            <div style="float: left">
                <div>
                    Countries</div>
                <select name="operatorcountries" multiple="multiple" style="height: 200px">
                    <%  foreach (Country c in OperatorDAO.GetCountries())
                        {
                    %>
                    <option cont="<%= c.Continent %>" value="<%= c.CountryID %>">
                        <%= c.FullName%>
                    </option>
                    <%
               
                        } %>
                </select>
            </div>
            <div style="clear: both">
            </div>
            <input type="hidden" name="opid" />
            <input type="submit" value="save" name="opcountriesbtn" />
            <div id="Status">
            </div>
        </form>
    </div>
</asp:Content>
