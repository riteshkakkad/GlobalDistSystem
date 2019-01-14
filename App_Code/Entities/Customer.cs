using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using NHibernate;
using NHibernate.Cfg;
using Iesi.Collections;
using System.Collections;
using System.Security.Cryptography;
using Newtonsoft.Json;

namespace Entities
{
    public class Customer
    {
        private Int64 _CustomerID;
        private String _Name;
        private String _Email;
        private String _Password;
        private String _Country;
        private String _Email1;
        private String _ContactNo;
        private String _ContactNo1;
        private String _Address;
        private String _CompanyName;
        private Int32 _Status;

        public Int64 CustomerID
        {
            get { return _CustomerID; }
            set { _CustomerID = value; }
        }
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public String Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        public String Country
        {
            get { return _Country; }
            set { _Country = value; }
        }
        public String Email
        {
            get { return _Email; }
            set { _Email = value; }
        }
        [JsonIgnore]
        public String Password
        {
            get { return _Password; }
            set { _Password = value; }
        }
        public String ContactNo
        {
            get { return _ContactNo; }
            set { _ContactNo = value; }
        }
        public String Email1
        {
            get { return _Email1; }
            set { _Email1 = value; }
        }
        public String ContactNo1
        {
            get { return _ContactNo1; }
            set { _ContactNo1 = value; }
        }
        public String Address
        {
            get { return _Address; }
            set { _Address = value; }
        }
        public String CompanyName
        {
            get { return _CompanyName; }
            set { _CompanyName = value; }
        }
        public Customer()
        {
           
        }

    }
}
