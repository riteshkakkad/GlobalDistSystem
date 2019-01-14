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

namespace Entities
{
    public class OperatorRequest
    {
        private Int64 _OperatorRequestID;
        private Operator _Operator;
        private BookRequest _Request;
        private DateTime _TimeOfRequest;
        private Int16 _Status;
     
        public OperatorRequest()
        {
           
        }
        public Int64 OperatorRequestID
        {
            get { return _OperatorRequestID; }
            set { _OperatorRequestID = value; }
        }
        public Int16 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Operator Operator
        {
            get { return _Operator; }
            set { _Operator = value; }
        }
        public BookRequest Request
        {
            get { return _Request; }
            set { _Request = value; }
        }
        public DateTime TimeOfRequest
        {
            get { return _TimeOfRequest; }
            set { _TimeOfRequest = value; }
        }
        
        

    }
}
