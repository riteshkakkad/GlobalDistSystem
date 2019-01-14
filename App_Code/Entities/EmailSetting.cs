using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Entities
{
    public class EmailSetting
    {
        private String _ID;
        private String _EmailType;
        private String _EmailContent;
        private String _Subject;
        private Boolean _Send;

        public String ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public String EmailType
        {
            get { return _EmailType; }
            set { _EmailType = value; }
        }
        public String EmailContent
        {
            get { return _EmailContent; }
            set { _EmailContent = value; }
        }
        public String Subject
        {
            get { return _Subject; }
            set { _Subject = value; }
        }
        public Boolean Send
        {
            get { return _Send; }
            set { _Send = value; }
        }  
        public EmailSetting()
        {

        }
    }
}
