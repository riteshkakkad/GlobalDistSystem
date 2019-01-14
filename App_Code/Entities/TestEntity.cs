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
using Iesi.Collections;
namespace Entities
{
    public class TestEntity
    {
        private String _ICAOCODE;
        private ListSet _testproperty = new ListSet();
        public String ID
        {
            get { return _ICAOCODE; }
            set { _ICAOCODE = value; }
        }
        public ListSet TestProperty
        {
            get { return _testproperty; }
            set { _testproperty = value; }
        }
        public TestEntity()
        {
            //
            // TODO: Add constructor logic here
            //
        }

    }
}
