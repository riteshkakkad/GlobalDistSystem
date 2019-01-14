using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using NHibernate.UserTypes;
using NHibernate;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using Iesi.Collections;
namespace Helper
{
    class StringListUserType : IUserType
    {
        private const char cStringSeparator = '#';

        #region Equals member

        bool IUserType.Equals(object x, object y)
        {
           
            if (x == null || y == null) return false;
            ListSet xl = (ListSet)x;
            ListSet yl = (ListSet)y;
            if (xl.Count != yl.Count) return false;
            Boolean retvalue = xl.Minus(yl).Count == 0;
            return retvalue;
        }

        #endregion

        #region IUserType Members

        public object Assemble(object cached, object owner)
        {
            return cached;
        }

        public object DeepCopy(object value)
        {
            ListSet obj = (ListSet)value;
            ListSet retvalue = new ListSet(obj);
            return retvalue;
        }

        public object Disassemble(object value)
        {
            return value;
        }

        public int GetHashCode(object x)
        {
            return x.GetHashCode();
        }

        public bool IsMutable
        {
            get { return true; }
        }

        public object NullSafeGet(System.Data.IDataReader rs, string[] names, object owner)
        {
            ListSet result = new ListSet();
            Int32 index = rs.GetOrdinal(names[0]);
            if (rs.IsDBNull(index) || String.IsNullOrEmpty((String)rs[index]))
                return result;
            foreach (String s in ((String)rs[index]).Split(cStringSeparator))
                result.Add(s);
            return result;
        }

        public void NullSafeSet(System.Data.IDbCommand cmd, object value, int index)
        {
            if (value == null || value == DBNull.Value)
            {
                NHibernateUtil.String.NullSafeSet(cmd, null, index);
            }
            ListSet stringList = (ListSet)value;
            StringBuilder sb = new StringBuilder();
            foreach (String s in stringList)
            {
                sb.Append(s);
                sb.Append(cStringSeparator);
            }
            if (sb.Length > 0) sb.Length--;
            NHibernateUtil.String.Set(cmd, sb.ToString(), index);
        }

        public object Replace(object original, object target, object owner)
        {
            return original;
        }

        public Type ReturnedType
        {
            get { return typeof(ListSet); }
        }

        public NHibernate.SqlTypes.SqlType[] SqlTypes
        {
            get { return new NHibernate.SqlTypes.SqlType[] { NHibernateUtil.String.SqlType }; }
        }

        #endregion
    }
}