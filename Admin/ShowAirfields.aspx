<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ShowAirfields.aspx.cs" Inherits="ShowAirfields" Title="Untitled Page" %>

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
    addcountrynames();
$.editable.addInputType('countries', {
    element : function(settings, original) {
        var input = $('select[name=country]').clone();
        input.find("option[value=all]").remove();
        $(this).append(input);
        return(input);
    }
});

$('.editcountries').editable("UpdateAirfields.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
         
          return {aid: jQuery.trim($(this).parents("tr.main-table:eq(0)").find("td:first").text()),property:'countries'};
      
         },
         type:'countries',
         style   : 'display: inline',
         callback:function(){
         
         addcountrynames($(this).parents("tr:eq(0)")) ;
         
         }
     });
     $('.edit').editable("UpdateAirfields.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         submitdata : function(value, settings) {
                return {aid: jQuery.trim($(this).parents("tr.main-table:eq(0)").find("td:first").text()),property:$(this).parents("td:eq(0)").attr('class')};
         },
         callback:function(value,settings){
            
         
         }
         ,
          onsubmit:function(settings, original){
          if($(this).parents("span:eq(0)").hasClass("required"))
          {
             if($(this).find("input[type=text]").val()=="")
             {
              alert("Field Required.");
               original.editing = false;
              $(original).html(original.revert);
              return false;
             }   
          }
          if($(this).parents("span:eq(0)").hasClass("number"))
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
     $('.editselectew').editable("UpdateAirfields.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'E':'E','W':'W'}",
         submitdata : function(value, settings) {
                return {aid: jQuery.trim($(this).parents("tr.main-table:eq(0)").find("td:first").text()),property:$(this).parents("td:eq(0)").attr('class')};
         },
         style   : 'display: inline'
     });
      $('.editselectns').editable("UpdateAirfields.ashx", {
         indicator : '<img src="../css/indicator.gif">',
         tooltip   : 'Double click to edit...',
         event     : "dblclick",
         submit    : "OK",
         type:'select',
         data:"{'N':'N','S':'S'}",
         submitdata : function(value, settings) {
                return {aid: jQuery.trim($(this).parents("tr.main-table:eq(0)").find("td:first").text()),property:$(this).parents("td:eq(0)").attr('class')};
         },
         style   : 'display: inline'
     });
    
    $(".remove").click(function(){
    
        if(confirm("Are you sure?"))
        return true;
        else 
        return false;
    
    
    });
    
    });
var addcountrynames=function(row){

    var countryhead=$("#alist th:contains('Country')");

    var i=$("#alist tr:eq(0) th").index(countryhead);
    if(row)
    {
        var temp=row.find("td:eq("+i+")");
        var cid= jQuery.trim(temp.text());
        if(cid!="")
            temp.text($("select[name=country] option[value="+cid+"]").text());
 
    }else
    {
       
        $("#alist tr").each(function(index){
        var temp=$(this).find("td:eq("+i+")");
        var cid= jQuery.trim(temp.text());
        if(cid!="")
            temp.text($("select[name=country] option[value="+cid+"]").text());

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
        String country = "IN";
        if (Request.Params.Get("country") != null)
        {
            country = Request.Params.Get("country");
        }
        IList<Airfield> afulllist = AirfieldDAO.GetAirfields(Request.QueryString);
        IList<Airfield> alist = AirfieldDAO.GetAirfields(Request.QueryString, pageid, 15);
        
    
    %>
    <table class="bluetable">
        <tr>
            <th style="text-align: center">
                <form action="showairfields.aspx" method="get">
                    <span>ICAO</span>
                    <input type="text" name="icao" style="width:100px" value="<%= Request.QueryString.Get("icao") %>" />
                    <span>City</span>
                    <input type="text" name="city" style="width:100px" value="<%= Request.QueryString.Get("city") %>" />
                    <span>State</span>
                    <input type="text" name="state" style="width:100px" value="<%= Request.QueryString.Get("state") %>" />
                    <span>Select Country: </span>
                    <select name="country">
                        <% foreach (Country c in OperatorDAO.GetCountries())
                           {
                               if (c.CountryID == country)
                               {
                        %>
                        <option value="<%= c.CountryID %>" selected>
                            <%= c.FullName%>
                        </option>
                        <%
                            }
                            else
                            {
                        %>
                        <option value="<%= c.CountryID %>">
                            <%= c.FullName%>
                        </option>
                        <%
                            }
                        } %>
                    </select>
                    <input type="hidden" name="pageid" value="<%= pageid %>" />
                    <input type="submit" class="buttons" name="searchbtn" value="search" style="margin-left: 10px;width:80px" />
                </form>
            </th>
        </tr>
    </table>
    <br />
    <span class=brown>Pages: </span><span id="pages">
        <%
            Int32 noofpages = (Int32)Math.Ceiling(afulllist.Count / 15.0);

            for (int i = 1; i <= noofpages; i++)
            {
                if (i != pageid)
                {
        %>
        <a href="<%= AdminBO.GetPagingURL(Request.QueryString,"ShowAirfields.aspx", i) %>"
            style="margin-right: 5px">
            <%= i %>
        </a>
        <%
            }
            else
            {
        %>
        <span style="margin-right: 5px">
            <%=i %>
        </span>
        <%
            }
        }
           
        %>
    </span>
    <table class="bluetable" style="margin-top: 10px;width:950px" id="alist">
        <tr>
            <th>
                ICAO<br />
                CODE</th>
            <th>
                IATA<br />
                CODE</th>
            <th>
                Airfield Name</th>
            <th>
                City</th>
            <th>
                State</th>
            <th>
                Country</th>
            <th>
                Longitude</th>
            <th>
                Lattitude</th>
            <th>
                Runway</th>
            <th>
                Altitude</th>
            <th>
                Alternative<br /> names</th>
            <th>
            </th>
        </tr>
        <%
            if (alist.Count > 0)
            {
                foreach (Airfield a in alist)
                {
        %>
        <tr class="main-table">
            <td>
                <%= a.ICAOCODE%>
            </td>
            <td class="iatacode">
                <div class="edit">
                    <%= a.IATACode%>
                </div>
            </td>
            <td class="airfieldname">
                <div class="edit required">
                    <%= a.AirfieldName%>
                </div>
            </td>
            <td class="city">
                <div class="edit">
                    <%= a.City%>
                </div>
            </td>
            <td class="state">
                <div class="edit">
                    <%= a.State %>
                </div>
            </td>
            <td class="editcountries">
                <%= a.Country %>
            </td>
            <td>
                <table class="noborder">
                    <tr>
                        <td class="longdegrees">
                            <span class="edit required number">
                                <%= a.LongitudeDegrees %>
                            </span>
                            <sup>o</sup></td>
                        <td class="longmins">
                            <span class="edit required number">
                                <%=a.LongitudeMinutes%>
                            </span>
                           <sup>'</sup>
                        </td>
                        <td class="longew">
                            <div class="editselectew">
                                <%= a.EW %>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <table class="noborder">
                    <tr>
                        <td class="latdegrees">
                            <span class="edit required number">
                                <%= a.LattitudeDegrees %>
                            </span>
                            <sup>o</sup></td>
                        <td class="latmins required number">
                            <span class="edit">
                                <%=a.LattitudeMinutes%>
                            </span>
                            <sup>'</sup>
                        </td>
                        <td class="latew">
                            <div class="editselectns">
                                <%= a.NS %>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <%= a.Runway%>
            </td>
            <td>
                <%= a.Altitude%>
            </td>
            <td class="alternatenames">
                <div class="edit">
                    <%= a.AlternativeNames %>
                </div>
            </td>
            <td>
                <a href="UpdateAirfields.ashx?aid=<%= a.ICAOCODE %>&removeairfield=1" class="remove small-link">
                    Remove</a></td>
        </tr>
        <%
            }
        }
        else
        {
        %>
        <tr>
            <td colspan="11" align="center">
                No airfields found.</td>
        </tr>
        <%
            } %>
    </table>
</asp:Content>
