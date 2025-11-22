<%@ Page Title="Admin Dashboard - Marathi Matrimony" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="JivanBandhan4.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .admin-dashboard {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            padding: 25px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
            color: white;
        }
        
        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0,0,0,0.3);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .stat-icon {
            font-size: 2rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }
        
        .quick-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }
        
        .recent-activities {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .activity-item {
            padding: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        
        .bg-primary-light { background: rgba(102, 126, 234, 0.2); }
        .bg-success-light { background: rgba(40, 167, 69, 0.2); }
        .bg-warning-light { background: rgba(255, 193, 7, 0.2); }
        .bg-danger-light { background: rgba(220, 53, 69, 0.2); }
        .bg-info-light { background: rgba(23, 162, 184, 0.2); }
        .bg-purple-light { background: rgba(102, 16, 242, 0.2); }
        
        .table-responsive {
            border-radius: 15px;
            overflow: hidden;
        }
        
        .admin-table {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
        }
        
        .admin-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px;
            font-weight: 600;
        }
        
        .admin-table td {
            padding: 12px 15px;
            vertical-align: middle;
            border-color: rgba(0,0,0,0.1);
        }
        
        .btn-admin {
            border: none;
            border-radius: 10px;
            padding: 8px 15px;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .btn-admin-primary {
            background: rgba(102, 126, 234, 0.9);
            color: white;
        }
        
        .btn-admin-danger {
            background: rgba(220, 53, 69, 0.9);
            color: white;
        }
        
        .btn-admin-success {
            background: rgba(40, 167, 69, 0.9);
            color: white;
        }
        
        .btn-admin-warning {
            background: rgba(255, 193, 7, 0.9);
            color: white;
        }
        
        .btn-admin:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        .form-control-admin {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 10px;
            color: white;
            backdrop-filter: blur(10px);
        }
        
        .form-control-admin:focus {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255,255,255,0.5);
            color: white;
            box-shadow: none;
        }
        
        .form-control-admin::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .badge-admin {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        
        .badge-success { background: rgba(40, 167, 69, 0.2); color: #51cf66; border: 1px solid rgba(40, 167, 69, 0.3); }
        .badge-warning { background: rgba(255, 193, 7, 0.2); color: #ffd43b; border: 1px solid rgba(255, 193, 7, 0.3); }
        .badge-danger { background: rgba(220, 53, 69, 0.2); color: #ff6b6b; border: 1px solid rgba(220, 53, 69, 0.3); }
        .badge-info { background: rgba(23, 162, 184, 0.2); color: #66d9e8; border: 1px solid rgba(23, 162, 184, 0.3); }
        .badge-primary { background: rgba(102, 126, 234, 0.2); color: #748ffc; border: 1px solid rgba(102, 126, 234, 0.3); }
        
        @media (max-width: 768px) {
            .quick-stats-grid {
                grid-template-columns: 1fr;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-dashboard">
        <div class="container-fluid">
            <!-- Page Header -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="glass-card">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="mb-2">🏠 Admin Dashboard</h1>
                                <p class="mb-0">Welcome back, <asp:Label ID="lblAdminName" runat="server" Text="Admin" Font-Bold="true"></asp:Label>! Here's what's happening today.</p>
                            </div>
                            <div class="col-md-4 text-right">
                                <div class="d-flex justify-content-end gap-3 flex-wrap">
                                    <span class="badge badge-admin badge-primary p-2">
                                        📅 <asp:Label ID="lblCurrentDate" runat="server" Text=""></asp:Label>
                                    </span>
                                    <span class="badge badge-admin badge-success p-2">
                                        👥 Total Users: <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats Grid -->
            <div class="quick-stats-grid">
                <!-- Total Users -->
                <div class="glass-card text-center">
                    <div class="stat-icon">👥</div>
                    <div class="stat-number"><asp:Label ID="lblTotalUsersCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Users</div>
                    <div class="small mt-2">
                        <span class="text-success">↑ <asp:Label ID="lblNewUsersToday" runat="server" Text="0"></asp:Label> today</span>
                    </div>
                </div>

                <!-- Verified Profiles -->
                <div class="glass-card text-center">
                    <div class="stat-icon">✅</div>
                    <div class="stat-number"><asp:Label ID="lblVerifiedProfiles" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Verified Profiles</div>
                    <div class="small mt-2">
                        <span class="text-warning"><asp:Label ID="lblVerificationRate" runat="server" Text="0%"></asp:Label> verification rate</span>
                    </div>
                </div>

                <!-- Premium Members -->
                <div class="glass-card text-center">
                    <div class="stat-icon">⭐</div>
                    <div class="stat-number"><asp:Label ID="lblPremiumMembers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Premium Members</div>
                    <div class="small mt-2">
                        <span class="text-info"><asp:Label ID="lblPremiumRate" runat="server" Text="0%"></asp:Label> premium rate</span>
                    </div>
                </div>

                <!-- Pending Verifications -->
                <div class="glass-card text-center">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-number"><asp:Label ID="lblPendingVerifications" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Pending Verifications</div>
                    <div class="small mt-2">
                        <a href="ProfileVerification.aspx" class="text-white">Review now →</a>
                    </div>
                </div>

                <!-- Total Revenue -->
                <div class="glass-card text-center">
                    <div class="stat-icon">💰</div>
                    <div class="stat-number">₹<asp:Label ID="lblTotalRevenue" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Revenue</div>
                    <div class="small mt-2">
                        <span class="text-success">₹<asp:Label ID="lblRevenueToday" runat="server" Text="0"></asp:Label> today</span>
                    </div>
                </div>

                <!-- Reported Profiles -->
                <div class="glass-card text-center">
                    <div class="stat-icon">⚠️</div>
                    <div class="stat-number"><asp:Label ID="lblReportedProfiles" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Reported Profiles</div>
                    <div class="small mt-2">
                        <a href="ReportedProfiles.aspx" class="text-white">Take action →</a>
                    </div>
                </div>
            </div>

            <!-- Charts and Detailed Stats -->
            <div class="row">
                <!-- Left Column - Charts -->
                <div class="col-lg-8">
                    <!-- Registration Chart -->
                    <div class="chart-container">
                        <h5 class="mb-4">📈 User Registrations (Last 30 Days)</h5>
                        <canvas id="registrationChart" height="250"></canvas>
                    </div>

                    <!-- Revenue Chart -->
                    <div class="chart-container">
                        <h5 class="mb-4">💵 Revenue Overview (Last 30 Days)</h5>
                        <canvas id="revenueChart" height="250"></canvas>
                    </div>
                </div>

                <!-- Right Column - Recent Activities & Quick Actions -->
                <div class="col-lg-4">
                    <!-- Recent Activities -->
                    <div class="glass-card">
                        <h5 class="mb-4">🔔 Recent Activities</h5>
                        <div class="recent-activities">
                            <asp:Repeater ID="rptRecentActivities" runat="server">
                                <ItemTemplate>
                                    <div class="activity-item">
                                        <div class="activity-icon bg-primary-light">
                                            <i class="fas fa-user-plus"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-bold"><%# Eval("ActivityText") %></div>
                                            <small class="text-muted"><%# Eval("TimeAgo") %></small>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="glass-card">
                        <h5 class="mb-4">⚡ Quick Actions</h5>
                        <div class="d-grid gap-2">
                            <asp:Button ID="btnVerifyProfiles" runat="server" Text="✅ Verify Profiles" 
                                CssClass="btn btn-admin btn-admin-success" OnClick="btnVerifyProfiles_Click" />
                            <asp:Button ID="btnViewReports" runat="server" Text="📊 View Reports" 
                                CssClass="btn btn-admin btn-admin-primary" OnClick="btnViewReports_Click" />
                            <asp:Button ID="btnManageUsers" runat="server" Text="👥 Manage Users" 
                                CssClass="btn btn-admin btn-admin-warning" OnClick="btnManageUsers_Click" />
                            <asp:Button ID="btnPaymentHistory" runat="server" Text="💰 Payment History" 
                                CssClass="btn btn-admin btn-admin-success" OnClick="btnPaymentHistory_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Registrations Table -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="chart-container">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="mb-0">🆕 Recent Registrations</h5>
                            <asp:Button ID="btnViewAllUsers" runat="server" Text="View All Users" 
                                CssClass="btn btn-admin btn-admin-primary" OnClick="btnViewAllUsers_Click" />
                        </div>
                        
                        <div class="table-responsive">
                            <asp:GridView ID="gvRecentUsers" runat="server" AutoGenerateColumns="False" 
                                CssClass="table admin-table" EmptyDataText="No recent registrations found."
                                DataKeyNames="UserID" OnRowCommand="gvRecentUsers_RowCommand">
                                <Columns>
                                    <asp:TemplateField HeaderText="User ID">
                                        <ItemTemplate>
                                            #<%# Eval("UserID") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Profile">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center">
                                                <asp:Image ID="imgUser" runat="server" CssClass="rounded-circle me-3" 
                                                    ImageUrl='<%# GetUserPhoto(Eval("UserID")) %>' 
                                                    Width="40" Height="40" onerror="this.src='../../Images/default-profile.jpg'" />
                                                <div>
                                                    <div class="fw-bold"><%# Eval("FullName") %></div>
                                                    <small class="text-muted"><%# Eval("Gender") %>, <%# CalculateAge(Eval("DateOfBirth")) %> yrs</small>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="City" HeaderText="Location" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='badge-admin <%# GetStatusBadgeClass(Eval("IsActive"), Eval("IsVerified")) %>'>
                                                <%# GetStatusText(Eval("IsActive"), Eval("IsVerified")) %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CreatedDate" HeaderText="Registered On" 
                                        DataFormatString="{0:dd MMM yyyy}" />
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <div class="btn-group btn-group-sm">
                                                <asp:LinkButton ID="btnView" runat="server" CssClass="btn btn-admin btn-admin-primary" 
                                                    CommandName="View" CommandArgument='<%# Eval("UserID") %>' ToolTip="View Profile">
                                                    <i class="fas fa-eye"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnVerify" runat="server" CssClass="btn btn-admin btn-admin-success" 
                                                    CommandName="Verify" CommandArgument='<%# Eval("UserID") %>' ToolTip="Verify Profile"
                                                    Visible='<%# !Convert.ToBoolean(Eval("IsVerified")) %>'>
                                                    <i class="fas fa-check"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnBlock" runat="server" CssClass="btn btn-admin btn-admin-danger" 
                                                    CommandName="Block" CommandArgument='<%# Eval("UserID") %>' ToolTip="Block User"
                                                    Visible='<%# Convert.ToBoolean(Eval("IsActive")) %>'>
                                                    <i class="fas fa-ban"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Registration Chart
            const regCtx = document.getElementById('registrationChart').getContext('2d');
            const registrationChart = new Chart(regCtx, {
                type: 'line',
                data: {
                    labels: <%= GetRegistrationChartLabels() %>,
                    datasets: [{
                        label: 'New Registrations',
                        data: <%= GetRegistrationChartData() %>,
                        borderColor: 'rgba(102, 126, 234, 1)',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            labels: {
                                color: 'white'
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                color: 'rgba(255,255,255,0.1)'
                            },
                            ticks: {
                                color: 'white'
                            }
                        },
                        y: {
                            grid: {
                                color: 'rgba(255,255,255,0.1)'
                            },
                            ticks: {
                                color: 'white'
                            }
                        }
                    }
                }
            });

            // Revenue Chart
            const revCtx = document.getElementById('revenueChart').getContext('2d');
            const revenueChart = new Chart(revCtx, {
                type: 'bar',
                data: {
                    labels: <%= GetRevenueChartLabels() %>,
                    datasets: [{
                        label: 'Revenue (₹)',
                        data: <%= GetRevenueChartData() %>,
                        backgroundColor: 'rgba(40, 167, 69, 0.8)',
                        borderColor: 'rgba(40, 167, 69, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            labels: {
                                color: 'white'
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                color: 'rgba(255,255,255,0.1)'
                            },
                            ticks: {
                                color: 'white'
                            }
                        },
                        y: {
                            grid: {
                                color: 'rgba(255,255,255,0.1)'
                            },
                            ticks: {
                                color: 'white'
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>