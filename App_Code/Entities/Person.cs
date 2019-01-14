using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Entities
{
    public class Person
    {
        private Int64 _Id;
        private String _Name;
        private String _Email;
        private String _Phone;
        private String _Description;
        public Person()
        {
            
        }
        public Int64 Id
        {
            get { return _Id; }
            set { _Id = value; }
        }
        public String Name
        {
            get { return _Name; }
            set { _Name = value; }
        }
        public String Email
        {
            get { return _Email; }
            set { _Email = value; }
        }
        public String Phone
        {
            get { return _Phone; }
            set { _Phone = value; }
        }
        public String Description
        {
            get { return _Description; }
            set { _Description = value; }
        }
     
    }
}
