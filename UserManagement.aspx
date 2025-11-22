<%@ Page Title="User Management - Admin Panel" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="JivanBandhan4.Admin.UserManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .user-management-container {
            background: #f8f9fa;
            min-height: calc(100vh - 70px);
            padding: 20px 0;
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            padding: 25px;
            margin-bottom: 25px;
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid rgba(0,0,0,0.1);
        }
        
        .form-control-admin {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(0,0,0,0.1);
            border-radius: 10px;
            padding: 10px 15px;
            margin-bottom: 15px;
        }
        
        .form-control-admin:focus {
            background: rgba(255, 255, 255, 1);
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-admin {
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 2px;
        }
        
        .btn-admin-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-admin-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .btn-admin-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        
        .btn-admin-danger {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
        }
        
        .btn-admin-info {
            background: linear-gradient(135deg, #17a2b8 0%, #6f42c1 100%);
            color: white;
        }
        
        .btn-admin-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .btn-admin:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .admin-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .admin-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px;
            font-weight: 600;
            text-align: center;
        }
        
        .admin-table td {
            padding: 12px 15px;
            vertical-align: middle;
            border-color: rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .admin-table tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e9ecef;
        }
        
        .badge-admin {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        
        .badge-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .badge-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }
        .badge-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .badge-info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .badge-primary { background: #d1e7ff; color: #084298; border: 1px solid #b6d4fe; }
        .badge-secondary { background: #e2e3e5; color: #383d41; border: 1px solid #d6d8db; }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-action {
            width: 35px;
            height: 35px;
            border: none;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .btn-view { background: #17a2b8; color: white; }
        .btn-edit { background: #28a745; color: white; }
        .btn-verify { background: #ffc107; color: white; }
        .btn-block { background: #dc3545; color: white; }
        .btn-delete { background: #6c757d; color: white; }
        
        .btn-action:hover {
            transform: scale(1.1);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 600;
        }
        
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        
        .pagination-admin .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
        }
        
        .pagination-admin .page-link {
            color: #667eea;
            border: 1px solid #dee2e6;
            padding: 8px 16px;
        }
        
        .pagination-admin .page-link:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
        }
        
        .export-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-action {
                width: 30px;
                height: 30px;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .export-buttons {
                flex-direction: column;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderTitle" runat="server">
    User Management
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="user-management-container">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="glass-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="mb-2">User Management</h1>
                                <p class="mb-0 text-muted">Manage all registered users, verify profiles, and handle user accounts</p>
                            </div>
                            <div class="col-md-4 text-right">
                                <div class="d-flex justify-content-end gap-3 flex-wrap">
                                    <asp:Button ID="btnAddUser" runat="server" Text="Add New User" 
                                        CssClass="btn btn-admin btn-admin-success" OnClick="btnAddUser_Click" />
                                    <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" 
                                        CssClass="btn btn-admin btn-admin-info" OnClick="btnExportExcel_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblActiveUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Active Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblVerifiedUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Verified Profiles</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblPremiumUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Premium Members</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblBlockedUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Blocked Users</div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label fw-bold">Search by Name/Email</label>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-admin" 
                            placeholder="Enter name or email..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label fw-bold">Gender</label>
                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control form-control-admin" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlGender_SelectedIndexChanged">
                            <asp:ListItem Value="">All Genders</asp:ListItem>
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label fw-bold">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control form-control-admin" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                            <asp:ListItem Value="">All Status</asp:ListItem>
                            <asp:ListItem Value="Active">Active</asp:ListItem>
                            <asp:ListItem Value="Blocked">Blocked</asp:ListItem>
                            <asp:ListItem Value="Unverified">Unverified</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label fw-bold">City</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control form-control-admin" 
                            AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label fw-bold">Registration Date</label>
                        <div class="d-flex gap-2">
                            <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" 
                                CssClass="form-control form-control-admin" placeholder="From Date"></asp:TextBox>
                            <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" 
                                CssClass="form-control form-control-admin" placeholder="To Date"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center flex-wrap">
                            <div>
                                <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" 
                                    CssClass="btn btn-admin btn-admin-primary" OnClick="btnApplyFilters_Click" />
                                <asp:Button ID="btnResetFilters" runat="server" Text="Reset" 
                                    CssClass="btn btn-admin btn-admin-secondary" OnClick="btnResetFilters_Click" />
                            </div>
                            <div class="d-flex align-items-center gap-3">
                                <span class="text-muted">Show</span>
                                <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control form-control-admin" 
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged" Width="80px">
                                    <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                    <asp:ListItem Text="25" Value="25" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="50" Value="50"></asp:ListItem>
                                    <asp:ListItem Text="100" Value="100"></asp:ListItem>
                                </asp:DropDownList>
                                <span class="text-muted">entries</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Users GridView -->
            <div class="glass-card">
                <div class="table-responsive">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover admin-table" DataKeyNames="UserID"
                        AllowPaging="True" PageSize="25" OnPageIndexChanging="gvUsers_PageIndexChanging"
                        OnRowCommand="gvUsers_RowCommand" OnRowDataBound="gvUsers_RowDataBound"
                        EmptyDataText="No users found matching your criteria."
                        ShowHeaderWhenEmpty="True">
                        <Columns>
                          
                            <asp:TemplateField HeaderText="ID">
                                <ItemTemplate>
                                    <small class="text-muted">#<%# Eval("UserID") %></small>
                                </ItemTemplate>
                                <ItemStyle Width="60px" />
                            </asp:TemplateField>

                          
                            <asp:TemplateField HeaderText="User Profile">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center">
                                        <asp:Image ID="imgUser" runat="server" CssClass="user-avatar me-3" 
                                            ImageUrl='<%# GetUserPhoto(Eval("UserID")) %>' 
                                            onerror="this.src='../../Images/default-profile.jpg'" />
                                        <div class="text-start">
                                            <div class="fw-bold"><%# Eval("FullName") %></div>
                                            <small class="text-muted d-block"><%# Eval("Email") %></small>
                                            <small class="text-muted"><%# Eval("Gender") %>, <%# CalculateAge(Eval("DateOfBirth")) %> yrs</small>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                       
                            <asp:TemplateField HeaderText="Location">
                                <ItemTemplate>
                                    <div class="text-start">
                                        <div><%# Eval("City") %></div>
                                        <small class="text-muted"><%# Eval("State") %></small>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Width="120px" />
                            </asp:TemplateField>

                        
                            <asp:TemplateField HeaderText="Profession">
                                <ItemTemplate>
                                    <div class="text-start">
                                        <div class="fw-bold"><%# Eval("Occupation") %></div>
                                        <small class="text-muted"><%# Eval("Education") %></small>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Width="150px" />
                            </asp:TemplateField>

                         
                            <asp:TemplateField HeaderText="Membership">
                                <ItemTemplate>
                                    <span class='badge-admin <%# GetMembershipBadgeClass(Eval("UserID")) %>'>
                                        <%# GetMembershipStatus(Eval("UserID")) %>
                                    </span>
                                </ItemTemplate>
                                <ItemStyle Width="100px" />
                            </asp:TemplateField>

                      
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge-admin <%# GetStatusBadgeClass(Eval("IsActive"), Eval("IsVerified")) %>'>
                                        <%# GetStatusText(Eval("IsActive"), Eval("IsVerified")) %>
                                    </span>
                                </ItemTemplate>
                                <ItemStyle Width="100px" />
                            </asp:TemplateField>

                          
                            <asp:TemplateField HeaderText="Registered On">
                                <ItemTemplate>
                                    <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd MMM yyyy") %>
                                </ItemTemplate>
                                <ItemStyle Width="120px" />
                            </asp:TemplateField>

                       
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                    
                                        <asp:LinkButton ID="btnView" runat="server" CssClass="btn-action btn-view" 
                                            CommandName="View" CommandArgument='<%# Eval("UserID") %>' 
                                            ToolTip="View Full Profile">
                                            <i class="fas fa-eye"></i>
                                        </asp:LinkButton>

                                    
                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-action btn-edit" 
                                            CommandName="Edit" CommandArgument='<%# Eval("UserID") %>' 
                                            ToolTip="Edit Profile">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>

                                     
                                        <asp:LinkButton ID="btnVerify" runat="server" CssClass="btn-action btn-verify" 
                                            CommandName="Verify" CommandArgument='<%# Eval("UserID") %>' 
                                            ToolTip='<%# Convert.ToBoolean(Eval("IsVerified")) ? "Unverify Profile" : "Verify Profile" %>'
                                            Visible='<%# Convert.ToBoolean(Eval("IsActive")) %>'>
                                            <i class='<%# Convert.ToBoolean(Eval("IsVerified")) ? "fas fa-times" : "fas fa-check" %>'></i>
                                        </asp:LinkButton>

                                     
                                        <asp:LinkButton ID="btnBlock" runat="server" CssClass="btn-action btn-block" 
                                            CommandName="Block" CommandArgument='<%# Eval("UserID") %>' 
                                            ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Block User" : "Unblock User" %>'>
                                            <i class='<%# Convert.ToBoolean(Eval("IsActive")) ? "fas fa-ban" : "fas fa-check-circle" %>'></i>
                                        </asp:LinkButton>

                                    
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn-action btn-delete" 
                                            CommandName="Delete" CommandArgument='<%# Eval("UserID") %>' 
                                            ToolTip="Delete User" 
                                            OnClientClick="return confirm('Are you sure you want to delete this user? This action cannot be undone.');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Width="200px" />
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-admin" HorizontalAlign="Center" />
                        <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" />
                        <EmptyDataRowStyle CssClass="text-center py-4" />
                        <EmptyDataTemplate>
                            <div class="text-center py-4">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No Users Found</h4>
                                <p class="text-muted">No users match your current filter criteria.</p>
                                <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" 
                                    CssClass="btn btn-admin btn-admin-primary" OnClick="btnResetFilters_Click" />
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

            
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div class="text-muted">
                        Showing 
                        <asp:Label ID="lblStartRecord" runat="server" Text="0"></asp:Label> 
                        to 
                        <asp:Label ID="lblEndRecord" runat="server" Text="0"></asp:Label> 
                        of 
                        <asp:Label ID="lblTotalRecords" runat="server" Text="0"></asp:Label> 
                        entries
                    </div>
                    
               
                    <div class="export-buttons">
                        <asp:Button ID="btnExportSelected" runat="server" Text="Export Selected" 
                            CssClass="btn btn-admin btn-admin-info btn-sm" OnClick="btnExportSelected_Click" />
                        <asp:Button ID="btnExportAll" runat="server" Text="Export All" 
                            CssClass="btn btn-admin btn-admin-success btn-sm" OnClick="btnExportAll_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

   
    <asp:HiddenField ID="hdnSelectedUsers" runat="server" />

    <script>
        function selectUser(userId, checkbox) {
            var hiddenField = document.getElementById('<%= hdnSelectedUsers.ClientID %>');
            var selectedUsers = hiddenField.value ? hiddenField.value.split(',') : [];
            
            if (checkbox.checked) {
            
                if (!selectedUsers.includes(userId)) {
                    selectedUsers.push(userId);
                }
            } else {
            
                var index = selectedUsers.indexOf(userId);
                if (index > -1) {
                    selectedUsers.splice(index, 1);
                }
            }
            
            hiddenField.value = selectedUsers.join(',');
        }

        function selectAllUsers(selectAllCheckbox) {
            var checkboxes = document.querySelectorAll('.user-checkbox');
            var hiddenField = document.getElementById('<%= hdnSelectedUsers.ClientID %>');
            var selectedUsers = [];

            checkboxes.forEach(function (checkbox) {
                checkbox.checked = selectAllCheckbox.checked;
                if (selectAllCheckbox.checked) {
                    selectedUsers.push(checkbox.value);
                }
            });

            hiddenField.value = selectedUsers.join(',');
        }
    </script>
</asp:Content>