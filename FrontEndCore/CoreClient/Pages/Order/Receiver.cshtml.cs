using System;
using System.Threading.Tasks;
using CoreClient.Extensions;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class ReceiverModel : PageModel
  {
    [BindProperty]
    public Customer Receiver { get; set; }

    public void OnGet()
    {
      Receiver = TempData.GetWithKeep<Customer>("Receiver") ?? new Customer();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      TempData.Put("Receiver", Receiver);
      return RedirectToPage("/Order/Package");
    }
  }
}