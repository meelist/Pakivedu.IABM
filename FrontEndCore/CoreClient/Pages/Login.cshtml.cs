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
  public class LoginModel : PageModel
  {
    [BindProperty]
    public string UserName { get; set; }
    [BindProperty]
    public string Password { get; set; }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostAsync()
    {
      using (var client = new HttpClient())
      {
        client.BaseAddress = new Uri("http://localhost:8980/");

        dynamic json = new JObject();
        json.request = new JObject();
        json.request.userName = UserName;
        json.request.passWord = Password;

        var content = new StringContent(json.ToString(), Encoding.UTF8, "application/json");
        var response = await client.PostAsync("APIService/rest/APIService/Auth", content);
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