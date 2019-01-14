<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AddOperators.aspx.cs" Inherits="AddOperators" Title="Untitled Page" %>

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
    
       $("#addoperatorform").submit(function(){
            
            if(validate())
            {
            $.ajax({
            'url': 'UpdateOperators.ashx',
            'data': $("#addoperatorform").serialize()+"&operatoradd=1",
            'dataType': 'json',
            'type': 'POST',
            'beforeSend':function(){
            
              $("#Status").html("<img src='../images/loadingAnimation.gif' />");
              $('table.returnoperator').remove();
            },
            'success': function(data) {
            
                if(data['success'])
                {
                  $("#addoperatorform input[type=text],#addoperatorform input[type=password],#addoperatorform textarea").val("");
                 
                  $("#addoperatorform input[type=checkbox]").removeAttr("checked");
                  $("select[name=countries]").children("option").removeAttr('selected');
                 }
                  
                var headerrow="<tr><th>Login Email</th><th>Company Name</th><th>Contact No</th><th>Address</th><th>NSOP Reg No.</th><th>Operator Short Name</th><th>Alternate Email</th><th>Alternate<br> ContactNo</th><th>Country</th><th>Operated Countries</th><th></th></tr>";
                var resp="";
               $("#Status").html(data['text']);
               resp+="<tr><td>"+data['operator'].Email+"</td>";
               resp+="<td>"+data['operator'].CompanyName+"</td>";
               resp+="<td>"+data['operator'].ContactNo+"</td>";
               resp+="<td>"+data['operator'].Address+"</td>";
               resp+="<td>"+data['operator'].NSOPRegNo+"</td>";
               resp+="<td>"+data['operator'].OperatorShortName+"</td>";
               resp+="<td>"+data['operator'].Email1+"</td>";
               resp+="<td>"+data['operator'].ContactNo1+"</td>";
               resp+="<td class='country'>"+data['operator'].Country+"</td>";
               resp+="<td style='width:300px;'><div style='height:300px;overflow:auto' class='opcountries'>"+data['operator'].OperatorCountries.join(",")+"</div></td>";
               resp+="<td><a href='aircrafts.aspx?oid="+data['operator'].OperatorId+"' title='Aircrafts' target='_blank'>Aircrafts</a></td></tr>"
               $("<table class='returnoperator bluetable' style='margin-top:20px;margin-left:auto;margin-right:auto;width:900px'></table>").append(headerrow).append(resp).insertAfter($("#addoperatorform"));
                tb_init("a.thickbox");
               var orgelem= $(".opcountries").html();
               var resp="";
               $.each(orgelem.split(','),function(li,l){               
                resp+= $("select[name=countries]").find("option[value="+l+"]").text()+"<br>";
               });
               
               $(".opcountries").html(resp);
               
               $('.country').text($("select[name=countries]").find("option[value="+$('.country').text()+"]").text());
               window.scrollTo(999999,999999);
            }
            });
             return false;
            }
            else
            {
             return false;
            }
       
       
       });
       
      $("select[name=countries]").change(function(){
      
        $("input[class=continents]").each(function(i){
        
           
          var expsize= $("select[name=countries]").children("option[cont="+$(this).val()+"]").size(); 
          var actsize= $("select[name=countries]").children("option[cont="+$(this).val()+"]:selected").size(); 
          if(expsize>actsize)
           $(this).removeAttr("checked");
          else
            $(this).attr("checked","checked");
        });
      
      });
     
     
     $("input[class=continents]").click(function(){
     
 if($(this).is(":checked"))
  {
     $("select[name=countries]").children("option[cont="+$(this).val()+"]").attr('selected','selected');
   
  }
  else
  {
    $("select[name=countries]").children("option[cont="+$(this).val()+"]").removeAttr('selected');

  }
});
    
    });
 var validate=function(){
 

 
 var valid=true;
    $(".required,.number").removeClass("error");
    $("div.errortext").remove();
    $(".required").each(function(i){
    
     if($(this).val()=="")
      {
       valid=false;
       if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
         $(this).parents("td:eq(0)").append($("<div class='errortext'>* Required.</div>"));
       
       $(this).addClass('error');
      }
    
    });
    $(".number").each(function(){
    
     if($(this).val()!="" && isNaN($(this).val()))
      {
        
         valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext:contains('Number')").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Number Required.</div>"));
         
         $(this).addClass('error');
       }
    
    });
    $(".email").each(function(index){
    var temp=true;
    if($(this).val()=="")
     temp=false;
      
    if(!echeck($(this).val()) && temp)
      {
        valid=false;
          if($(this).parents("td:eq(0)").find("div.errortext").size()==0)
                $(this).parents("td:eq(0)").append($("<div class='errortext'>* Invalid Email.</div>"));
         
         $(this).addClass('error');
       }
          
    });
    
   return valid;
 

 
 
 }   
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <form id="addoperatorform">
        <table class="bluetable" style="width:700px;margin-left:auto;margin-right:auto">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Add Operator
                </th>
            </tr>
            <tr>
                <th>
                    Login Email
                </th>
                <td>
                    <input name="Email" type="text" class="required email" />
                    <div>
                        <input type="checkbox" name="generatepass" />
                        Generate Password
                    </div>
                </td>
            </tr>
            <tr>
                <th>
                    Company Name
                </th>
                <td>
                    <input name="operatorname" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Address
                </th>
                <td>
                    <textarea name="address" cols="20" rows="2" class="required"></textarea>
                </td>
            </tr>
            <tr>
                <th>
                    Contact No.
                </th>
                <td>
                    <input name="contactno" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Alternate Contact No.
                </th>
                <td>
                    <input name="alternatecontactno" type="text" />
                </td>
            </tr>
            <tr>
                <th>
                    Alternate Email
                </th>
                <td>
                    <input name="alternateemail" type="text" class="email" />
                </td>
            </tr>
            <tr>
                <th>
                    NSOP Registration No
                </th>
                <td>
                    <input name="nsopregno" type="text" class="required" />
                </td>
            </tr>
            <tr>
                <th>
                    Operator Short Name(to be displayed in invoice)
                </th>
                <td>
                    <input name="operatorshortname" type="text" />
                </td>
            </tr>
            <tr>
                <th>
                    Registered Country
                </th>
                <td>
                    <select name="country">
                        <%  foreach (Country c in OperatorDAO.GetCountries())
                            {
                        %>
                        <option value="<%= c.CountryID %>">
                            <%= c.FullName%>
                        </option>
                        <%
               
                            } %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>
                    Operated Countries
                </th>
                <td>
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
                        <select name="countries" multiple="multiple" style="height: 200px">
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
                </td>
            </tr>
            <tr>
                <th colspan="2">
                    <input type="submit" name="addoperatorbtn" class="buttons" value="Add" />
                    <div id="Status">
                    </div>
                </th>
            </tr>
        </table>
    </form>
</asp:Content>
