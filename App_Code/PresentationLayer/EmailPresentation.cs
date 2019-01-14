using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
namespace PresentationLayer
{
    public class EmailPresentation
    {
        public EmailPresentation()
        {

        }
        public static String GetSignature()
        {
            String resp = null;
            resp += "<div style='font-size:12px;font-family:Tahmoma'>";
            resp += "<table>";
            resp += "<tr><td>Regards,</td></tr>";
           
            resp += "<tr><th align='left'>Airnetz Global Charter Team<br></th></tr>";
            resp += "<tr><th align='left'>INDIA : </th></tr>";
            resp += "<tr><td>Airnetz Aviation Pvt. Ltd.</td></tr>";
            resp += "<tr><td>* Business Jet Charters * Helicopter Charters * Turbo Prop Charters *</td></tr>";
            resp += "<tr><td>TELE-BOOKING</td></tr>";
            resp += "<tr><td>India Cell : +91 9930403019</td></tr>";
            resp += "<tr><td>Land Line : +91 22 28079043</td></tr>";
            resp += "<tr><td><a href='http://www.airnetz.com' >www.airnetz.com</a><br></td></tr>";
            resp += "<tr><th align='left'>USA :</th></tr>";
            resp += "<tr><td>Airnetz Charter Inc.</td></tr>";
            resp += "<tr><td>4867 Ashford Dunwoody Road</td></tr>";
            resp += "<tr><td>#8111 Atlanta GA 30338</td></tr>";
            resp += "<tr><td>Phone : +1 608 554 0461<br></td></tr>";
            resp += "<tr><th align='left'>UK :</th></tr>";
            resp += "<tr><td>Airnetz Charter Inc.</td></tr>";
            resp += "<tr><td>Phone : +442081448025<br><br></td></tr>";
            resp += "<tr><td>© 2008 Airnetz Charter Inc. airnetzcharter.com, airnetz.com and their logos are trademark of Airnetz Charter Inc. and are used under license.<br></td></tr>";
            resp += "<tr><td>Airnetz Charter Inc. DOES NOT OWN, MAINTAIN or OPERATE AIRCRAFTS. AIRNETZ IS NOT A DIRECT OR INDIRECT AIR CARRIER. AIRNETZ is an online and offline travel information, scheduling and transaction service. All Charter Flight Services within USA are offered and provided by third party Federally licensed direct air carriers, certified under Federal Aviation Regulations Part 135 or Part 121 as issued by the Federal Aviation Administration.<br></td></tr>";
            resp += "</table>";
            resp += "</div>";
            return resp;

        }
        public static String GetHeader(String name)
        {
            String resp = "<div>";
            resp += "<h3>Dear "+name+",</h3>";
            resp += "</div>";
            return resp;
            
        }
        public static String GetQuoteEstimationTerms()
        {
            String resp = null;
            resp = "*Pricing disclaimer: All prices quoted are computer generated estimates. Final Quote will depend on availability of aircraft,actual flying time and type of aircraft used. Additional charges such as parking, hangar, facility use fees, customs, deicing, international operations charges, handling fees, flight phone use, catering, etc. are billed as incurred. After reviewing your trip requirements, an Airnetz Charter Inc. specialist will contact you to discuss the details of your trip. All flights are operated by non schedule operators certified under Federal Aviation Regulations Part 135 or Part 121 as issued by the Federal Aviation Administration.";
            return resp;
        }
    }
}
