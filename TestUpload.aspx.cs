using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.ComponentModel;
using Helper;
using BusinessLayer;
using Entities;
using System.Collections.Specialized;
using System.Collections.Generic;
using DataAccessLayer;

public partial class TestUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        /*Email email;
        MailAddress m;

        email = new Email();
        email.MailServerName = "mail.airnetzcharter.com";

        email.MailServerUserName = "admin@airnetzcharter.com";
        email.MailServerPassword = "admin7895";
        email.Subject = "check aircraft photo";
        m = new MailAddress("admin@airnetzcharter.com", "Airnetz Charter");
        email.From = m;
        email.Tos.Add("nikhil.khekade@gmail.com");
        
        email.sendEmail("done");*/
        BookRequest b = BookRequestDAO.FindBookRequestByID((long)51);
        NHibernateHelper.GetCurrentSession().Delete(b);



        

    }
    public enum CoordinateType { longitude, latitude };
    public static string DDtoDMS(double coordinate, CoordinateType type)
    {
        // Set flag if number is negative
        bool neg = coordinate < 0d;

        // Work with a positive number
        coordinate = Math.Abs(coordinate);

        // Get d/m/s components
        double d = Math.Floor(coordinate);
        coordinate -= d;
        coordinate *= 60;
        double m = Math.Floor(coordinate);
        coordinate -= m;
        coordinate *= 60;
        double s = Math.Round(coordinate);
        String dir = "";
        // Append compass heading
        switch (type)
        {
            case CoordinateType.longitude:
                dir = neg ? "W" : "E";
                break;
            case CoordinateType.latitude:
                dir = neg ? "S" : "N";
                break;
        }
        String dms = d + "." + m + "." + s + "." + dir;
        return dms;
    }


}
