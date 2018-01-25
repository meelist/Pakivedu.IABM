using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using Newtonsoft.Json;

namespace CoreClient.Extensions
{
  public static class TempDataExtensions
  {
    public static void Put<T>(this ITempDataDictionary tempData, string key, T value) where T : class
    {
      tempData[key] = JsonConvert.SerializeObject(value);
    }

    public static T Get<T>(this ITempDataDictionary tempData, string key) where T : class
    {
      object o;
      tempData.TryGetValue(key, out o);
      return o == null ? null : JsonConvert.DeserializeObject<T>((string)o);
    }

    public static T GetWithKeep<T>(this ITempDataDictionary tempData, string key) where T : class
    {
      object o;
      tempData.TryGetValue(key, out o);
      tempData.Keep(key);
      return o == null ? null : JsonConvert.DeserializeObject<T>((string)o);
    }
  }
}
