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
using Newtonsoft.Json;

namespace Entities
{
    public class Operator
    {

        private Int64 _OperatorId;
        private String _CompanyName;
        private String _Address;
        private String _ContactNo;
        private String _ContactNo1;
        private String _Email;
        private String _Password;
        private String _Email1;
        private String _NSOPRegNo;
        private String _License;
        private String _OperatorShortName;
        private String _Country;
        private Int32 _Status;
        private Int32 _Cancel0To24;
        private Int32 _Cancel24To48;
        private Int32 _Cancel48To72;
        private Int32 _CancelMoreThan72;

        private ListSet _OperatorCountries = new ListSet();
        private ISet _Aircrafts = new HashedSet();

        public Int64 OperatorId
        {
            get { return _OperatorId; }
            set { _OperatorId = value; }
        }
        [JsonIgnore]
        public ISet Aircrafts
        {
            get { return _Aircrafts; }
            set { _Aircrafts = value; }
        }
        public String Address
        {
            get { return _Address; }
            set { _Address = value; }
        }
        public String ContactNo
        {
            get { return _ContactNo; }
            set { _ContactNo = value; }
        }
        public String Country
        {
            get { return _Country; }
            set { _Country = value; }
        }
        public String ContactNo1
        {
            get { return _ContactNo1; }
            set { _ContactNo1 = value; }
        }
        public String Email
        {
            get { return _Email; }
            set { _Email = value; }
        }
        public String Email1
        {
            get { return _Email1; }
            set { _Email1 = value; }
        }
        public String CompanyName
        {
            get { return _CompanyName; }
            set { _CompanyName = value; }
        }
        public String License
        {
            get { return _License; }
            set { _License = value; }
        }
        public String NSOPRegNo
        {
            get { return _NSOPRegNo; }
            set { _NSOPRegNo = value; }
        }
        public ListSet OperatorCountries
        {
            get { return _OperatorCountries; }
            set { _OperatorCountries = value; }
        }
        public String OperatorShortName
        {
            get { return _OperatorShortName; }
            set { _OperatorShortName = value; }
        }
        [JsonIgnore]
        public String Password
        {
            get { return _Password; }
            set { _Password = value; }
        }
        public Int32 Cancel0To24
        {
            get { return _Cancel0To24; }
            set { _Cancel0To24 = value; }
        }
        public Int32 Cancel24To48
        {
            get { return _Cancel24To48; }
            set { _Cancel24To48 = value; }
        }
        public Int32 Cancel48To72
        {
            get { return _Cancel48To72; }
            set { _Cancel48To72 = value; }
        }
        public Int32 CancelMoreThan72
        {
            get { return _CancelMoreThan72; }
            set { _CancelMoreThan72 = value; }
        }
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Operator()
        {

        }
        


    }
}
