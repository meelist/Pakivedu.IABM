using System;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoreClient.Pages.Order
{
  public class ReceiverModel : PageModel
  {
    public Customer Sender { get; set; }
    public Customer Receiver { get; set; }
    public void OnGet()
    {
      Console.WriteLine();
    }


  }
}