using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Net.Mail;
using Helper;
using Entities;
using DataAccessLayer;
using Iesi.Collections;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using PresentationLayer;
using Exceptions;
using System.Security.Cryptography;

namespace BusinessLayer
{
    public class BookRequestBO
    {


        public BookRequestBO()
        {

        }

        public static Boolean CheckHeliportSupport(BookRequest b)
        {
            Boolean heliport = false;
            foreach (Leg l in b.Legs)
            {
                if (l.Source.IsHeliport() || l.Destination.IsHeliport())
                {
                    heliport = true;
                    break;
                }
            }

            if (heliport && !b.PlaneType.IsHelicopter())
                return false;
            else
                return true;
        }
        public static Double GetFinalBudget(Double actual, Country c)
        {
            if (c.Margin <= 0)
                return actual;

            Double temp = actual - c.Margin * actual / 100;
            temp = Math.Floor(temp);
            if (temp % 500 > 0)
            {
                temp = temp - temp % 500;
            }
            return temp;

        }
        public static Double GetFinalBid(Double actual, Country c)
        {
            if (c.Margin <= 0)
                return actual;
            Double temp = actual + c.Margin * actual / 100;
            temp = Math.Ceiling(temp);
            if (temp % 500 > 0)
            {
                temp = temp + temp % 500;
            }
            return temp;

        }
        public static Double GetQuickQuote(BookRequest b)
        {
            try
            {
                Double finalquote = 0;
                Airfield start = null, end = null;
                Int32 count = b.Legs.Count;
                foreach (Leg l in b.Legs)
                {
                    if (l.Sequence == 1)
                    {
                        start = l.Source;
                    }
                    if (l.Sequence == count)
                    {
                        end = l.Destination;
                    }

                    finalquote += GetLegQuickQuote(l.Source, l.Destination, b.PlaneType);

                }
                finalquote += GetLegQuickQuote(end, start, b.PlaneType);



                return finalquote;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static Double GetLegQuickQuote(Airfield Source, Airfield Destination, AirplaneType at)
        {

            try
            {
                Double distance = Source.GetDistaneFrom(Destination);
                Double flyingtime = at.CalculateTimeToTravelDistance(distance);

                Double TOTAL_QUOTE;

                if (flyingtime == 0)
                    TOTAL_QUOTE = 0;
                else
                {

                    if (flyingtime * 2 < 2)
                    {
                        flyingtime = 2;
                        TOTAL_QUOTE = (flyingtime * at.GetRateForCurrentSession().HourlyRate) / 2;
                    }
                    else
                    {
                        TOTAL_QUOTE = flyingtime * at.GetRateForCurrentSession().HourlyRate;
                    }

                }
                return TOTAL_QUOTE;
            }
            catch (Exception ex)
            {
                throw new AdminException("Airfields Not Found. Use Autocomplete feature");
            }



        }
        public static BookRequest AcceptBookRequest(BookRequest b)
        {
            try
            {
                b.Code = GetRequestCode(b);
                BookRequest book = BookRequestDAO.MakePersistent(b);
                return book;
            }
            catch (Exception ex)
            {
                throw new Exception("Problem");
            }

        }
        public static String gmapstring(BookRequest b)
        {

            String gmapstr = "http://maps.google.com/staticmap?size=300x300&maptype=mobile";
            String markers = "&markers=";
            String path = "&path=rgba:0xff0000ff,weight:5|";
            String key = "&key=ABQIAAAAgl32QoKG04P1ZBxYDdc1YxT9aaJEI2oRHrowRn4qpFJKIjABURRW3mkNQMqsNbL-SdLh7ZEILTSnhQ"; // put key here
            foreach (Leg l in b.Legs)
            {
                if (l.Sequence != 1)
                {
                    markers += "|";
                    path += "|";
                }

                markers += l.Source.GetLattitudeDecimal() + "," + l.Source.GetLongitudeDecimal() + ",blues";
                path += l.Source.GetLattitudeDecimal() + "," + l.Source.GetLongitudeDecimal();
                markers += "|";
                path += "|";
                markers += l.Destination.GetLattitudeDecimal() + "," + l.Destination.GetLongitudeDecimal() + ",blues";
                path += l.Destination.GetLattitudeDecimal() + "," + l.Destination.GetLongitudeDecimal();

            }

            gmapstr = gmapstr + markers + path + key;
            return gmapstr;

        }
        public static String gmapstring(EmptyLeg el)
        {

            String gmapstr = "http://maps.google.com/staticmap?size=300x300&maptype=mobile";
            String markers = "&markers=";
            String path = "&path=rgba:0xff0000ff,weight:5|";
            String key = "&key=ABQIAAAAgl32QoKG04P1ZBxYDdc1YxT9aaJEI2oRHrowRn4qpFJKIjABURRW3mkNQMqsNbL-SdLh7ZEILTSnhQ"; // put key here
            markers += el.Source.GetLattitudeDecimal() + "," + el.Source.GetLongitudeDecimal() + ",blues";
            path += el.Source.GetLattitudeDecimal() + "," + el.Source.GetLongitudeDecimal();
            markers += "|";
            path += "|";
            markers += el.Destination.GetLattitudeDecimal() + "," + el.Destination.GetLongitudeDecimal() + ",blues";
            path += el.Destination.GetLattitudeDecimal() + "," + el.Destination.GetLongitudeDecimal();
            gmapstr = gmapstr + markers + path + key;
            return gmapstr;

        }
        public static String gmapstring(FixedPriceCharter el)
        {

            String gmapstr = "http://maps.google.com/staticmap?size=300x300&maptype=mobile";
            String markers = "&markers=";
            String path = "&path=rgba:0xff0000ff,weight:5|";
            String key = "&key=ABQIAAAAgl32QoKG04P1ZBxYDdc1YxT9aaJEI2oRHrowRn4qpFJKIjABURRW3mkNQMqsNbL-SdLh7ZEILTSnhQ"; // put key here
            markers += el.Source.GetLattitudeDecimal() + "," + el.Source.GetLongitudeDecimal() + ",blues";
            path += el.Source.GetLattitudeDecimal() + "," + el.Source.GetLongitudeDecimal();
            markers += "|";
            path += "|";
            markers += el.Destination.GetLattitudeDecimal() + "," + el.Destination.GetLongitudeDecimal() + ",blues";
            path += el.Destination.GetLattitudeDecimal() + "," + el.Destination.GetLongitudeDecimal();
            gmapstr = gmapstr + markers + path + key;
            return gmapstr;

        }
        public static String GetRequestCode(BookRequest req)
        {
            String record = req.BookID + "" + req.ContactDetails.Name + req.ContactDetails.Email + req.Domain + req.GetEndingLeg() + req.GetStartingLeg();
            long hashOfRecord = record.GetHashCode();
            String hashValue = null;
            byte[] iByte = BitConverter.GetBytes(hashOfRecord);
            String secretKey = "AirnetzCharter";
            byte[] keyBytes = BitConverter.GetBytes(secretKey.GetHashCode());
            HMACSHA1 sha = new HMACSHA1(keyBytes);
            hashValue = removeDashes(BitConverter.ToString(sha.ComputeHash(iByte)));
            hashValue += req.BookID.ToString();
            return hashValue;
        }
        private static String removeDashes(String text)
        {
            String[] textarray = text.Split('-');
            text = null;
            for (int i = 0; i < textarray.Length; i++)
            {
                text = String.Concat(text, textarray[i]);
            }

            return text;
        }
    }

}
