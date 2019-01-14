using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Entities;
using DataAccessLayer;
using Iesi.Collections;
using System.Collections;
using NHibernate;
using System.Collections.Generic;
using Helper;
using System.Collections.Specialized;
using System.Xml;
using Exceptions;

namespace BusinessLayer
{
    public class AirfieldBO
    {
        public AirfieldBO()
        {

        }
        public static Int32 GetAutoassignedNumberForHeliports()
        {
            IList<Airfield> alist = AirfieldDAO.GetAutoassignedHeliports();
            Airfield temp = null;
            foreach (Airfield a in alist)
            {
                temp = a;
                break;
            }
            if (temp == null)
            {
                return 1;
            }
            else
            {
                String no = temp.ICAOCODE.Replace("A-A", "");
                return Int32.Parse(no) + 1;
            }
        }

        public static Int32 GetAutoassignedNumberForAirfields()
        {
            IList<Airfield> alist = AirfieldDAO.GetAutoassignedAirfields();
            Airfield temp = null;
            foreach (Airfield a in alist)
            {
                temp = a;
                break;
            }
            if (temp == null)
            {
                return 1;
            }
            else
            {
                String no = temp.ICAOCODE.Replace("B-B", "");
                return Int32.Parse(no) + 1;
            }
        }
        public static Int32 GetAutoassignedNumberForTemporary()
        {
            IList<Airfield> alist = AirfieldDAO.GetAutoassignedTemporary();
            Airfield temp = null;
            foreach (Airfield a in alist)
            {
                temp = a;
                break;
            }
            if (temp == null)
            {
                return 1;
            }
            else
            {
                String no = temp.ICAOCODE.Replace("T-T", "");
                return Int32.Parse(no) + 1;
            }
        }
        public static Airfield SaveAirfield(Airfield a)
        {
            Airfield at = AirfieldDAO.FindExactAirfield(a);
            if (at != null)
                return at;
            else
            {
                a.ICAOCODE = "T-T" + GetAutoassignedNumberForTemporary();
                at = AirfieldDAO.AddAirfield(a);
                return at;
            }
        }
        public static ListSet GetAirfields(String text)
        {
            ListSet aset = new ListSet();
            if (text.Contains("(") && text.Contains(")"))
            {


                String id = text.Substring(text.LastIndexOf("(") + 1, text.LastIndexOf(")") - text.LastIndexOf("(") - 1);
                if (id.Contains("Lat:") && id.Contains("Long:"))
                {
                    Airfield a = new Airfield();
                    a.ICAOCODE = "T-T" + RandomPassword.Generate(5);
                    a.AirfieldName = text.Remove(text.IndexOf(",")).Trim();
                    a.Country = text.Substring(text.IndexOf(",") + 1, text.IndexOf("(") - text.IndexOf(",") - 1).Trim();
                    foreach (String l in id.Split(",".ToCharArray()))
                    {
                        Double temp;
                        if (l.Contains("Lat:"))
                        {
                            temp = Double.Parse(l.Substring(l.LastIndexOf(":") + 1));
                            string[] parts = DDtoDMS(temp, CoordinateType.latitude).Split(".".ToCharArray());
                            a.LattitudeDegrees = Int32.Parse(parts[0]);
                            a.LattitudeMinutes = Int32.Parse(parts[1]);
                            a.NS = Char.Parse(parts[2]);

                        }
                        else if (l.Contains("Long:"))
                        {
                            temp = Double.Parse(l.Substring(l.LastIndexOf(":") + 1));
                            string[] parts = DDtoDMS(temp, CoordinateType.longitude).Split(".".ToCharArray());
                            a.LongitudeDegrees = Int32.Parse(parts[0]);
                            a.LongitudeMinutes = Int32.Parse(parts[1]);
                            a.EW = Char.Parse(parts[2]);
                        }

                    }
                    aset.Add(a);

                }
                else
                {
                    Airfield a = AirfieldDAO.FindAirfieldByID(id);
                    aset.Add(a);
                }

            }
            else
            {
                aset.AddAll(SearchAifields(text));
                if (aset.Count == 0)
                {
                    String[] keywords = text.Split(", ".ToCharArray());
                    foreach (String s in keywords)
                    {
                        if (s.Length >= 3)
                        {
                            aset.AddAll(SearchAifields(s));
                        }
                    }
                }



            }
            return aset;
        }
        public static ListSet SearchAifields(String text)
        {
            ListSet aset = new ListSet();
            IList<Airfield> alistbyname = AirfieldDAO.FindByAirfieldName(text, "Start");
            if (alistbyname.Count > 0)
            {
                foreach (Airfield a in alistbyname)
                {
                    aset.Add(a);
                }
            }
            Airfield abyicao = AirfieldDAO.FindAirfieldByICAO(text);
            if (abyicao != null)
                aset.Add(abyicao);
            Airfield abyiata = AirfieldDAO.FindAirfieldByIATA(text);
            if (abyiata != null)
                aset.Add(abyiata);

            IList<Airfield> alistbycity = AirfieldDAO.FindAirfieldByCity(text, "");
            if (alistbycity.Count > 0)
            {
                foreach (Airfield a in alistbycity)
                {
                    aset.Add(a);
                }
            }
            if (aset.Count == 0)
            {
                IList<Airfield> alistbystate = AirfieldDAO.FindAirfieldByState(text, "");
                if (alistbystate.Count > 0)
                {
                    foreach (Airfield a in alistbystate)
                    {
                        aset.Add(a);
                    }
                }
            }
            return aset;
        }
        public static ListSet RemoveHeliports(ListSet total)
        {
            Int32 count = total.Count;
            ListSet ls = new ListSet();

            foreach (Airfield a in total)
            {
                if (a.IsHeliport())
                    ls.Add(a);
            }

            total.RemoveAll(ls);
            if (count > 0 && total.Count == 0)
                throw new HeliportException();
            return total;

        }
        public static Airfield AirfieldFromAutoComplete(String text)
        {
            if (text.Contains("(") && text.Contains(")"))
            {
                String id = text.Substring(text.LastIndexOf("(") + 1, text.LastIndexOf(")") - text.LastIndexOf("(") - 1);
                Airfield a = AirfieldDAO.FindAirfieldByICAO(id);
                if (a != null)
                    return a;
                else
                    return null;
            }
            else
            {
                return null;
            }
        }
        public enum CoordinateType { longitude, latitude };
        public static string DDtoDMS(double coordinate, CoordinateType type)
        {
            // Set flag if number is negative
            bool neg = coordinate < 0d;

            // Work with a positive number
            coordinate = Math.Abs(coordinate);

            // Get d/m/s components
            double d = Math.Floor(coordinate);
            coordinate -= d;
            coordinate *= 60;
            double m = Math.Round(coordinate);

            String dir = "";
            // Append compass heading
            switch (type)
            {
                case CoordinateType.longitude:
                    dir = neg ? "W" : "E";
                    break;
                case CoordinateType.latitude:
                    dir = neg ? "S" : "N";
                    break;
            }
            String dms = d + "." + m + "." + dir;
            return dms;
        }

    }
}
