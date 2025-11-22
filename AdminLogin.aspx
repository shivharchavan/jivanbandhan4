<%@ Page Title="Admin Login - Marathi Matrimony" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="JivanBandhan4.Admin.AdminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .admin-login-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            color: white;
        }
        
        .form-control-admin {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 10px;
            color: white;
            padding: 12px 15px;
            margin-bottom: 20px;
        }
        
        .form-control-admin:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255,255,255,0.5);
            color: white;
            box-shadow: none;
        }
        
        .btn-admin-login {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 12px;
            border-radius: 10px;
            width: 100%;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-admin-login:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
    </style>

    <div class="admin-login-container">
        <div class="login-card">
            <div class="text-center mb-4">
                <h2>🏛️ Admin Login</h2>
                <p class="mb-0">JivanBandhan Matrimony Admin Panel</p>
            </div>
            
            <asp:Panel ID="pnlLogin" runat="server" DefaultButton="btnLogin">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-admin" 
                        placeholder="Enter username" required="true"></asp:TextBox>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                        CssClass="form-control form-control-admin" placeholder="Enter password" required="true"></asp:TextBox>
                </div>
                
                <asp:Button ID="btnLogin" runat="server" Text="🔐 Login" 
                    CssClass="btn btn-admin-login" OnClick="btnLogin_Click" />
                
                <div class="text-center mt-3">
                    <asp:Label ID="lblMessage" runat="server" Text="" CssClass="text-warning"></asp:Label>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>