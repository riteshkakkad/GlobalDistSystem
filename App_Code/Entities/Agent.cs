using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NHibernate;
using NHibernate.Cfg;
using Iesi.Collections;
using System.Collections;
using System.Security.Cryptography;
using Newtonsoft.Json;

namespace Entities
{
    public class Agent
    {
        private Int64 _AgentID;
        private String _Name;
        private String _Email;
        private String _Password;
        private String _Country;
        private String _Email1;
        private String _ContactNo;
        private String _ContactNo1;
        private String _AgentCode;
        private Int32 _Status;
        private String _BillingAddress;
        private String _Agency;
        private String _AgentFax;
        private String _Domain;
       
        public Int64 AgentID
        {
            get { return _AgentID; }
            set { _AgentID = value; }
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
        public String AgentCode
        {
            get { return _AgentCode; }
            set { _AgentCode = value; }
        }
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public String Domain
        {
            get { return _Domain; }
            set { _Domain = value; }
        }
        public String BillingAddress
        {
            get { return _BillingAddress; }
            set { _BillingAddress = value; }
        }
        public String Agency
        {
            get { return _Agency; }
            set { _Agency = value; }
        }
        public String AgentFax
        {
            get { return _AgentFax; }
            set { _AgentFax = value; }
        }
       

        public Agent()
        {

        }
        public void CalculateAgentCode()
        {
            String record = this.Name + this.Email + this.BillingAddress + this.AgentID + this.AgentFax + this.ContactNo + this.Status;
            long hashOfRecord = record.GetHashCode();
            String hashValue = null;
            byte[] iByte = BitConverter.GetBytes(hashOfRecord);
            String secretKey = "AirnetzCharter";
            byte[] keyBytes = BitConverter.GetBytes(secretKey.GetHashCode());
            HMACSHA1 sha = new HMACSHA1(keyBytes);
            hashValue = BitConverter.ToString(sha.ComputeHash(iByte)).Replace("-","");
            hashValue += this.AgentID.ToString();
            this.AgentCode = hashValue;
        }

        
    }
}
