using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Helper;
using Entities;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.ComponentModel;
using NHibernate;
using Iesi.Collections;
using DataAccessLayer;
using System.Text;
using System.Text.RegularExpressions;
using System.Reflection;
using System.Collections;
namespace BusinessLayer
{
    public class EmailBO
    {
        private Email _email = new Email();
        public Email email
        {
            get { return _email; }
            set { _email = value; }
        }
        public delegate void MailSender(String msg);
        private String _content;
        public String content
        {
            get { return _content; }
            set { _content = value; }
        }

        private String _subject;
        public String subject
        {
            get { return _subject; }
            set { _subject = value; }
        }
        private String _signature;
        public String signature
        {
            get { return _signature; }
            set { _signature = value; }
        }
        private Boolean _Send;
        public Boolean Send
        {
            get { return _Send; }
            set { _Send = value; }
        }
        public Country _country;
        public Country country
        {
            get { return _country; }
            set { _country = value; }
        }
        public EmailBO(String ID, String domain)
        {
            EmailSetting es = AdminDAO.GetEmailSettingByID(ID);
            Country c = AdminDAO.GetCountryByID(domain);
            content = es.EmailContent;
            subject = es.Subject;
            signature = c.Signature;
            country = c;
            Send = es.Send;
            MailAddress m;
            email.MailServerName = "mail.airnetzcharter.com";
            email.MailServerUserName = "admin@airnetzcharter.com";
            email.MailServerPassword = "admin7895";
            m = new MailAddress("admin@airnetzcharter.com", "Airnetz Charter");
            email.From = m;
            email.Subject = subject;
            foreach (String s in Default.adminemails.Split(",".ToCharArray()))
            {
                email.BCCs.Add(s.Trim());
            }
        }
        public EmailBO(String subject,String content, String domain)
        {
            Country c = AdminDAO.GetCountryByID(domain);
            this.content = content;
            this.subject = subject;
            signature = c.Signature;
            MailAddress m;
            email.MailServerName = "mail.airnetzcharter.com";
            email.MailServerUserName = "admin@airnetzcharter.com";
            email.MailServerPassword = "admin7895";
            m = new MailAddress("admin@airnetzcharter.com", "Airnetz Charter");
            email.From = m;
            email.Subject = subject;
            Send = true;
            foreach (String s in Default.adminemails.Split(",".ToCharArray()))
            {
                email.BCCs.Add(s.Trim());
            }
        }
        public void SendEmailToCustomer(Customer c)
        {
            email.Tos.Add(c.Email);
            if (c.Email1 != null && c.Email1.Trim() != "")
                email.Tos.Add(c.Email1);

            SendEmail(GetFinalContent(content, c));
        }
        public void SendEmailToCustomer(Customer c, BookRequest b)
        {
            email.Tos.Add(c.Email);
            if (c.Email1 != null && c.Email1.Trim() != "")
                email.Tos.Add(c.Email1);
            String temp = GetFinalContent(content, c);
            temp = temp.Replace("{{BookRequest}}", GetRequestContent(b, false));
            SendEmail(temp);
        }
        public void SendEmailToAgent(Agent a)
        {
            email.Tos.Add(a.Email);
            if (a.Email1 != null && a.Email1.Trim() != "")
                email.Tos.Add(a.Email1);

            SendEmail(GetFinalContent(content, a));
        }
        public void SendEmailToAgent(Agent a, BookRequest b)
        {
            email.Tos.Add(a.Email);
            if (a.Email1 != null && a.Email1.Trim() != "")
                email.Tos.Add(a.Email1);
            SendEmail(GetFinalContent(content, a));
            String temp = GetFinalContent(content, a);
            temp = temp.Replace("{{BookRequest}}", GetRequestContent(b, false));
            SendEmail(temp);
        }
        public void SendEmailToOperator(Operator o)
        {
            email.Tos.Add(o.Email);
            if (o.Email1 != null && o.Email1.Trim() != "")
                email.Tos.Add(o.Email1);
            SendEmail(GetFinalContent(content, o));
        }
        public void SendEmailToOperator(Operator o, BookRequest b)
        {
            email.Tos.Add(o.Email);
            if (o.Email1 != null && o.Email1.Trim() != "")
                email.Tos.Add(o.Email1);
            String temp = GetFinalContent(content, o);
            temp = temp.Replace("{{BookRequest}}", GetRequestContent(b, false));
            SendEmail(temp);
        }
        public void SendEmailToOperators(ISet Operators)
        {
            email.Tos.Add("admin@airnetzcharter.com");
            foreach (Operator op in Operators)
            {
                email.BCCs.Add(op.Email);
            }
            SendEmail(content);
        }
        public void SendEmailToOperators(ISet Operators, BookRequest b)
        {
            email.Tos.Add("admin@airnetzcharter.com");
            foreach (Operator op in Operators)
            {
                email.BCCs.Add(op.Email);
            }
            String temp = content;
            temp = temp.Replace("{{BookRequest}}", GetRequestContent(b, false));
            SendEmail(temp);
        }
        public void SendEmailToAdmin()
        {
            email.Tos.Add("admin@airnetzcharter.com");
            SendEmail(content);
        }
        public void SendEmailToAdmin(BookRequest b)
        {
            email.Tos.Add("admin@airnetzcharter.com");
            String temp = content;
            temp = temp.Replace("{{BookRequest}}", GetRequestContent(b, false));
            SendEmail(temp);
        }

        public void SendDetailedQuoteToCustomer(String emailid, String quote)
        {
            email.Tos.Add(emailid);
            SendEmail(content.Replace("{{DetailedQuote}}", quote) + "<br><br>" + country.PricingDisclaimer + "<br><br>");
        }
        public void SendEmailToList(ArrayList emaillist)
        {
            if (Send && content != null)
            {
                bool temp = true;
                foreach (String e in emaillist)
                {
                    if (temp)
                    {
                        email.Tos.Add(e.Trim());
                        temp = false;
                    }
                    else
                    {
                        email.BCCs.Add(e.Trim());
                    }
                }
                MailSender m = new MailSender(SendEmailAsync);
                m.BeginInvoke("<html><head>" + Default.emailcss + "</head><body>" + content + signature + "</body></html>", null, null);
            }
        }
        public void SendEmail(String content)
        {
            if (Send && content != null)
            {
                MailSender m = new MailSender(SendEmailAsync);
                m.BeginInvoke("<html><head>" + Default.emailcss + "</head><body>" + content + signature + "</body></html>", null, null);
            }
        }
        public void SendEmailAsync(String msg)
        {
            email.sendEmail(msg);
        }
        public string GetFinalContent(String contentwithplaceholder, object o)
        {
            try
            {
                String[] placeholderlist = GetPlaceHolders(contentwithplaceholder);
                String resp = "";
                foreach (String s in placeholderlist)
                {
                    if (s != "DetailedQuote" && s != "BookRequest")
                    {
                        String temp = s.Replace((o.GetType().Name + "-"), "");
                        temp = o.GetType().GetProperty(temp).GetValue(o, null).ToString();
                        contentwithplaceholder = contentwithplaceholder.Replace("{{" + s + "}}", temp.ToString());
                    }
                }
                return contentwithplaceholder;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public String[] GetPlaceHolders(String content)
        {

            Regex r = new Regex("{{\\w+[-]\\w+}}", RegexOptions.IgnoreCase);
            MatchCollection mc = r.Matches(content);
            String[] slist = new String[mc.Count];
            int i = 0;
            foreach (Match m in mc)
            {
                slist[i] = m.Value.Trim().Replace("{{", "").Replace("}}", "");
                i++;
            }
            return slist;
        }
        public String GetRequestContent(BookRequest b, bool admin)
        {
            if (admin)
            {
                String resp = b.GetLegString() + " for " + b.PAX + " passengers starting on " + b.GetStartingLeg().Date.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US")) + " from " + b.ContactDetails.Name;
                return resp;
            }
            else
            {
                String resp = b.GetLegString() + " for " + b.PAX + " passengers starting on " + b.GetStartingLeg().Date.ToString("F", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"));
                return resp;
            }
        }

    }
}
