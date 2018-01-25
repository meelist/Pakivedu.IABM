using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace CoreClient.Pages
{
  public class RegisterModel : PageModel
  {
    [BindProperty]
    public Customer Customer { get; set; }

    public void OnGet()
    {
      Customer = new Customer();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      using (var client = new HttpClient())
      {
        client.BaseAddress = new Uri("http://localhost:8980/");

        dynamic json = new JObject();
        json.request = new JObject();
        json.request.customerName = Customer.CustomerName;
        json.request.telephone = Customer.Telephone;
        json.request.address = Customer.Address;
        json.request.email = Customer.Email;
        json.request.zipcode = Customer.ZipCode;
        json.request.country = Customer.Country;
        json.request.userName = Customer.UserName;
        json.request.password = Customer.Password;
        json.request.companyKey = Customer.CompanyKey;

        var content = new StringContent(json.ToString(), Encoding.UTF8, "application/json");
        var response = await client.PostAsync("APIService/rest/APIService/Customer", content);
        if (!response.IsSuccessStatusCode)
        {
          return Page();// Call to API failed
        }
        var respContent = await response.Content.ReadAsStringAsync();
        var data = JsonConvert.DeserializeObject<ResponseBase>(respContent);
        if (!data.Response.success)
        {
          return Page(); // TODO:display error from data
        }
      }
      return RedirectToPage("/Index");
    }
  }
}