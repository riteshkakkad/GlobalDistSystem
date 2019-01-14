using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.ComponentModel;
using System.Collections;

namespace Helper
{
    public class Email
    {

        private MailAddress _From;
        private ArrayList _Tos= new ArrayList();
        private ArrayList _CCs= new ArrayList();
        private ArrayList _BCCs= new ArrayList();
        private String _MailServerName;
        private Int32 _Port = 25;
        private String _Subject;
        private String _MailServerUserName;
        private String _MailServerPassword;
        private Attachment _Attachment;

        public MailAddress From
        {
            get { return _From; }
            set { _From = value; }
        }
        public ArrayList Tos
        {
            get { return _Tos; }
            set { _Tos = value; }
        }
        public ArrayList CCs
        {
            get { return _CCs; }
            set { _CCs = value; }
        }
        public ArrayList BCCs
        {
            get { return _BCCs; }
            set { _BCCs = value; }
        }
        public String MailServerName
        {
            get { return _MailServerName; }
            set { _MailServerName = value; }
        }
        public Int32 Port
        {
            get { return _Port; }
            set { _Port = value; }
        }
        public String Subject
        {
            get { return _Subject; }
            set { _Subject = value; }
        }
        public String MailServerUserName
        {
            get { return _MailServerUserName; }
            set { _MailServerUserName = value; }
        }
        public String MailServerPassword
        {
            get { return _MailServerPassword; }
            set { _MailServerPassword = value; }
        }
        public Attachment Attachment
        {
            get { return _Attachment; }
            set { _Attachment = value; }
        }
       

        public Email()
        {

        }
        public Boolean sendEmail(String email)
        {
           
            
            System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();

            try
            {

                foreach (String To in this.Tos)
                {
                    msg.To.Add(To);
                }
                foreach (String BCC in this.BCCs)
                {
                    msg.Bcc.Add(BCC);
                }
                foreach (String CC in this.CCs)
                {
                    msg.CC.Add(CC);
                }

                msg.From = this.From;
                msg.Subject = this.Subject;
                msg.SubjectEncoding = System.Text.Encoding.UTF8;
                if (Attachment != null)
                {
                    msg.Attachments.Add(Attachment);
                }
                msg.Body = email;
                msg.BodyEncoding = System.Text.Encoding.UTF8;
                msg.IsBodyHtml = true;
                msg.Priority = MailPriority.High;
                SmtpClient client = new SmtpClient();
                client.Credentials = new System.Net.NetworkCredential(this.MailServerUserName, this.MailServerPassword);
                client.Port = this.Port;//or use 587            
              
                client.Host = this.MailServerName;

                object userState = msg;
        
                client.SendAsync(msg,"Test");
            }
            catch (Exception ex)
            {
                return false;
            }
            return true;
        }

        
    }
}
