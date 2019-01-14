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
using NHibernate.Collection;
using Iesi.Collections;
using Newtonsoft.Json;



namespace Entities
{
    
    public class AirplaneType
    {
        private String _PlaneTypeID;
        private String _PlaneTypeName;
        private Int32 _InitialDistance;
        private Int32 _MiddleDistance;
        private Double _MiddleSpeed;
        private Double _InitialSpeed;
        private Double _MaximumSpeed;
        private String _Capacity;
        private String _ParentCategory;
       
        private ISet _AirplaneTypeRates = new HashedSet();
       

        public String PlaneTypeID
        {
            get { return _PlaneTypeID; }
            set { _PlaneTypeID = value; }
        }
       
        public String PlaneTypeName
        {  
            get { return _PlaneTypeName; }
            set { _PlaneTypeName = value; }
        }
        public Int32 InitialDistance
        {
            get { return _InitialDistance; }
            set { _InitialDistance = value; }
        }
        public Int32 MiddleDistance
        {
            get { return _MiddleDistance; }
            set { _MiddleDistance = value; }
        }
        public Double MiddleSpeed
        {
            get { return _MiddleSpeed; }
            set { _MiddleSpeed = value; }
        }
        public Double MaximumSpeed
        {
            get { return _MaximumSpeed; }
            set { _MaximumSpeed = value; }
        }
        public Double InitialSpeed
        {
            get { return _InitialSpeed; }
            set { _InitialSpeed = value; }
        }

        public String Capacity
        {
            get { return _Capacity; }
            set { _Capacity = value; }
        }
        public String ParentCategory
        {
            get { return _ParentCategory; }
            set { _ParentCategory = value; }
        }
        [JsonIgnore]
        public ISet AirplaneTypeRates
        {
            get { return _AirplaneTypeRates; }
            set { _AirplaneTypeRates = value; }
        }

        public AirplaneType()
        {
            
        }
        public AirplaneTypeRate GetRateForCurrentSession()
        {
            
            String country = HttpContext.Current.Session["Country"].ToString();

            AirplaneTypeRate temp = null;
            foreach(AirplaneTypeRate atr in  this.AirplaneTypeRates)
            {
                if (atr.Country.CountryID == country)
                {
                    temp = atr;
                    break;
                }
            }
            return temp;

        }
        public Double CalculateTimeToTravelDistance(Double distance)
        {
            Double time = 0;
            if (distance == 0)
                time = 0;
            else
            {
                distance = distance / 2;
                Double initDistance = distance > this.InitialDistance ? this.InitialDistance : distance;
                Double remainder = distance - initDistance > 0 ? distance - initDistance : 0;
                Double middleDistance = remainder > this.MiddleDistance ? this.MiddleDistance : remainder;
                remainder = remainder - middleDistance > 0 ? remainder - middleDistance : 0;
                Double halfFlightTime = initDistance / this.InitialSpeed + middleDistance / this.MiddleSpeed + remainder / this.MaximumSpeed;
                time = halfFlightTime * 2;
            }
            return time;
        }
        public Boolean IsHelicopter()
        {

            return (this.ParentCategory=="Helicopter");

        }

    }
}
