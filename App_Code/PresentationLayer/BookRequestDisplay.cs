using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Entities;

namespace PresentationLayer
{
    public class BookRequestDisplay
    {
        public BookRequestDisplay()
        {

        }
        public static String GetBookRequest(BookRequest b)
        {

            String resp = null;
            resp += "<table cellspacing='5'>";
            resp += "<tr>";
            resp += "<td>";
            resp += "<span style='margin-right: 5px; font-weight: bold'>Trip Type</span>:" + b.TripType;
            resp += "</td>";
            resp += "</tr>";
            resp += "<table cellspacing='5'>";
            resp += "<tr>";
            resp += "<td>";
            resp += "<span style='margin-right: 5px; font-weight: bold'>Plane Type</span>:" + b.PlaneType.PlaneTypeName.Trim();
            resp += "</td>";
            resp += "</tr>";
            resp += "</table>";
            resp += "<table cellspacing='5'>";
            resp += "<tr>";
            resp += "<td>";
            resp += "<span style='margin-right: 5px; font-weight: bold'>No of Passengers</span>:" + b.PAX;
            resp += "</td>";
            resp += "</tr>";
            resp += "</table>";


            foreach (Leg l in b.Legs)
            {
                resp += "<table cellspacing='5'>";
                resp += "<td>";
                resp += " <span style='color: #B02B2C;padding-top:10px;padding-bottom:5px;font-weight:bold;'>Leg " + l.Sequence + "</span>";
                resp += "</td><td></td></tr>";
                resp += "<tr>";
                resp += "<td><span style='font-weight: bold'>From</span><br>" + l.Source.GetAirfieldString() + "</td>";
                resp += "<td><span style='font-weight: bold'>To</span><br>" + l.Destination.GetAirfieldString() + "</td>";
                resp += "</tr>";
                resp += "<tr>";
                resp += "<td><span style='font-weight: bold'>Date(MM/DD/YYYY)</span><br>" + l.Date.ToShortDateString() + "</td>";
                resp += "<td><span style='font-weight: bold'>Time</span><br>" + l.Date.ToShortTimeString() + "</td>";
                resp += "</tr>";
                resp += "</table>";


            }
            return resp;
        }

        public static String GetPersonalDetails(Contact c)
        {
            String resp = null;

            resp += "<table cellspacing='5'>";
            resp += "<tr>";
            resp += "<td><span style='color: #B02B2C;padding-top:10px;padding-bottom:5px;font-weight:bold;'>Personal Details </span></td>";
            resp += "</tr>";
            resp += "<tr>";
            resp += "<td><span style='font-weight: bold'>Name</span></td>";
            resp += "<td>" + c.Name + "</td>";
            resp += "</tr>";
            resp += "<tr>";
            resp += "<td><span style='font-weight: bold'>Email</span></td>";
            resp += "<td>" + c.Email + "</td>";
            resp += "</tr>";
            resp += "<tr>";
            resp += "<td><span style='font-weight: bold'>Phone No</span></td>";
            resp += "<td>" + c.Phone + "</td>";
            resp += "</tr>";
            resp += "<tr>";
            resp += "<td><span style='font-weight: bold'>Other Details</span></td>";
            resp += "<td>" + ((c.Description == "") ? "Not Specified" : c.Description ).ToString()+ "</td>";
            resp += "</tr>";
            resp += "</table>";
            return resp;
        }
    }
}
