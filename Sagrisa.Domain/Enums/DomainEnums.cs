namespace Sagrisa.Domain.Enums
{
    public enum UserRole
    {
        Cliente = 1,
        Vendedor = 2,
        Supervisor = 3,
        Gerente = 4,
        Director = 5,
        Admin = 6
    }

    public enum OrderStatus
    {
        Draft = 1,
        PendingApproval = 2,
        Approved = 3,
        Rejected = 4,
        Fulfilled = 5
    }

    public enum InvoiceStatus
    {
        Unpaid = 1,
        Pending = 2,
        Partial = 3,
        Paid = 4,
        Cancelled = 5,
        Overdue = 6
    }

    public enum PaymentMethod
    {
        Efectivo = 1,
        Transferencia = 2,
        Cheque = 3
    }

    public enum PaymentStatus
    {
        Pending = 1,
        Applied = 2,
        Rejected = 3
    }
}
