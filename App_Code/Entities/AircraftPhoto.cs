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
    public class AircraftPhoto
    {
        private Int64 _PhotoID;
        private String _Caption;
        private Boolean _DisplayPic;
        private Airplane _Aircraft;

        public Int64 PhotoID
        {
            get { return _PhotoID; }
            set { _PhotoID = value; }
        }
        public String Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }
        public Boolean DisplayPic
        {
            get { return _DisplayPic; }
            set { _DisplayPic = value; }
        }
        public Airplane Aircraft
        {
            get { return _Aircraft; }
            set { _Aircraft = value; }
        }

        public AircraftPhoto()
        {
           
        }
    }
}
