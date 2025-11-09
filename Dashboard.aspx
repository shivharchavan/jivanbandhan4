
<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        
        .profile-header-large::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -75px;
            left: 50%;
            transform: translateX(-50%);
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            z-index: 3;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 4;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 95px 20px 20px;
            text-align: center;
            background: transparent;
            position: relative;
            z-index: 2;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <asp:Label ID="remainingMessages" runat="server" Text="5"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <asp:Label ID="remainingInterests" runat="server" Text="2"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and premium features
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large" id="profileHeaderBackground" runat="server">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest with Block Check and Membership Limit Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining interests
            const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
            if (remainingInterests <= 0) {
                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;

                                // Update remaining interests count
                                const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check and Membership Limit Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining messages
            const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
            if (remainingMessages <= 0) {
                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function(isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                
                                // Update remaining messages count
                                const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

        // Notification Functions
        function initializeNotifications() {
            loadNotifications();
            setInterval(loadNotifications, 30000); // Refresh every 30 seconds
            
            // Notification bell click event
            $('#btnNotificationBell').click(function(e) {
                e.stopPropagation();
                $('#notificationDropdown').toggle();
            });
            
            // Mark all as read
            $('#btnMarkAllRead').click(function() {
                markAllNotificationsAsRead();
            });
            
            // Close dropdown when clicking outside
            $(document).click(function() {
                $('#notificationDropdown').hide();
            });
        }

        function loadNotifications() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetNotifications",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        const data = JSON.parse(response.d);
                        updateNotificationUI(data);
                    }
                },
                error: function () {
                    console.log('Error loading notifications');
                }
            });
        }

        function updateNotificationUI(data) {
            // Update badge counts
            if (data.TotalUnread > 0) {
                $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
            } else {
                $('#<%= totalNotificationBadge.ClientID %>').hide();
            }
            
            if (data.UnreadInterests > 0) {
                $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
            } else {
                $('#<%= interestNotification.ClientID %>').hide();
            }
            
            if (data.UnreadMessages > 0) {
                $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
            } else {
                $('#<%= messageNotification.ClientID %>').hide();
            }
            
            // Update notification list
            const notificationList = $('#notificationList');
            notificationList.empty();
            
            if (data.Notifications.length === 0) {
                notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
            } else {
                data.Notifications.forEach(notification => {
                    const notificationItem = $(`
                        <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                            <div class="notification-content">${notification.Message}</div>
                            <div class="notification-time">${notification.TimeAgo}</div>
                        </div>
                    `);
                    
                    notificationItem.click(function() {
                        markNotificationAsRead(notification.NotificationID);
                        handleNotificationClick(notification);
                    });
                    
                    notificationList.append(notificationItem);
                });
            }
        }

        function markNotificationAsRead(notificationID) {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkNotificationAsRead",
                data: JSON.stringify({
                    notificationID: notificationID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        // Remove the unread style
                        $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                        loadNotifications(); // Refresh counts
                    }
                }
            });
        }

        function markAllNotificationsAsRead() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkAllNotificationsAsRead",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        loadNotifications();
                        showNotification('All notifications marked as read!', 'success');
                    }
                }
            });
        }

        function handleNotificationClick(notification) {
            // Handle navigation based on notification type
            switch (notification.Type) {
                case 'Interest':
                    window.location.href = 'Interests.aspx';
                    break;
                case 'Message':
                    window.location.href = 'Messages.aspx';
                    break;
                case 'ProfileView':
                    window.location.href = 'ProfileViews.aspx';
                    break;
                default:
                    // Do nothing
                    break;
            }

            // Close dropdown
            $('#notificationDropdown').hide();
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            initializeNotifications();
            console.log('Dashboard loaded successfully');
        });
    </script>
</asp:Content>





















<%--<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -60px;
            left: 50%;
            transform: translateX(-50%);
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 10;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 80px 20px 20px;
            text-align: center;
            background: transparent;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <asp:Label ID="remainingMessages" runat="server" Text="5"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <asp:Label ID="remainingInterests" runat="server" Text="2"></asp:Label>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and premium features
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest with Block Check and Membership Limit Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining interests
            const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
            if (remainingInterests <= 0) {
                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;

                                // Update remaining interests count
                                const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check and Membership Limit Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining messages
            const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
            if (remainingMessages <= 0) {
                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function(isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                
                                // Update remaining messages count
                                const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

        // Notification Functions
        function initializeNotifications() {
            loadNotifications();
            setInterval(loadNotifications, 30000); // Refresh every 30 seconds
            
            // Notification bell click event
            $('#btnNotificationBell').click(function(e) {
                e.stopPropagation();
                $('#notificationDropdown').toggle();
            });
            
            // Mark all as read
            $('#btnMarkAllRead').click(function() {
                markAllNotificationsAsRead();
            });
            
            // Close dropdown when clicking outside
            $(document).click(function() {
                $('#notificationDropdown').hide();
            });
        }

        function loadNotifications() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetNotifications",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        const data = JSON.parse(response.d);
                        updateNotificationUI(data);
                    }
                },
                error: function () {
                    console.log('Error loading notifications');
                }
            });
        }

        function updateNotificationUI(data) {
            // Update badge counts
            if (data.TotalUnread > 0) {
                $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
            } else {
                $('#<%= totalNotificationBadge.ClientID %>').hide();
            }
            
            if (data.UnreadInterests > 0) {
                $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
            } else {
                $('#<%= interestNotification.ClientID %>').hide();
            }
            
            if (data.UnreadMessages > 0) {
                $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
            } else {
                $('#<%= messageNotification.ClientID %>').hide();
            }
            
            // Update notification list
            const notificationList = $('#notificationList');
            notificationList.empty();
            
            if (data.Notifications.length === 0) {
                notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
            } else {
                data.Notifications.forEach(notification => {
                    const notificationItem = $(`
                        <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                            <div class="notification-content">${notification.Message}</div>
                            <div class="notification-time">${notification.TimeAgo}</div>
                        </div>
                    `);
                    
                    notificationItem.click(function() {
                        markNotificationAsRead(notification.NotificationID);
                        handleNotificationClick(notification);
                    });
                    
                    notificationList.append(notificationItem);
                });
            }
        }

        function markNotificationAsRead(notificationID) {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkNotificationAsRead",
                data: JSON.stringify({
                    notificationID: notificationID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        // Remove the unread style
                        $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                        loadNotifications(); // Refresh counts
                    }
                }
            });
        }

        function markAllNotificationsAsRead() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkAllNotificationsAsRead",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        loadNotifications();
                        showNotification('All notifications marked as read!', 'success');
                    }
                }
            });
        }

        function handleNotificationClick(notification) {
            // Handle navigation based on notification type
            switch (notification.Type) {
                case 'Interest':
                    window.location.href = 'Interests.aspx';
                    break;
                case 'Message':
                    window.location.href = 'Messages.aspx';
                    break;
                case 'ProfileView':
                    window.location.href = 'ProfileViews.aspx';
                    break;
                default:
                    // Do nothing
                    break;
            }

            // Close dropdown
            $('#notificationDropdown').hide();
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            initializeNotifications();
            console.log('Dashboard loaded successfully');
        });
    </script>
</asp:Content>--%>






















<%--<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -60px;
            left: 50%;
            transform: translateX(-50%);
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 10;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 80px 20px 20px;
            text-align: center;
            background: transparent;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        /* Notification Styles */
        .notification-badge {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 3px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: 8px;
            right: 8px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        .notification-badge-main {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 0.7rem;
            font-weight: bold;
            position: absolute;
            top: -5px;
            right: -5px;
            min-width: 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .notification-container {
            position: relative;
            display: inline-block;
        }

        .notification-dropdown {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 350px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1000;
            margin-top: 10px;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px 15px 0 0;
            color: white;
        }

        .notification-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item.unread {
            background: rgba(220, 53, 69, 0.1);
            border-left: 3px solid #dc3545;
        }

        .notification-item.read {
            opacity: 0.7;
        }

        .notification-content {
            font-size: 0.85rem;
            color: #333;
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 0.7rem;
            color: #666;
        }

        .notification-footer {
            padding: 10px 15px;
            text-align: center;
            border-top: 1px solid rgba(0,0,0,0.1);
            background: rgba(0,0,0,0.02);
            border-radius: 0 0 15px 15px;
        }

        .nav-item {
            position: relative;
        }

        /* Membership Status Styles */
        .membership-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-left: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: pulse 2s infinite;
        }

        .membership-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }

        .membership-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }

        .membership-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .membership-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }

        .upgrade-prompt {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .upgrade-btn {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .upgrade-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }

        .membership-limits {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .limit-item:last-child {
            border-bottom: none;
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
            
            .notification-dropdown {
                width: 300px;
                right: -50px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap align-items-center">
                            <!-- Notification Bell -->
                            <div class="notification-container position-relative">
                                <button id="btnNotificationBell" class="btn notification-bell" style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.3); color: white; border-radius: 50%; width: 50px; height: 50px; position: relative;">
                                    <i class="fas fa-bell"></i>
                                    <span id="totalNotificationBadge" runat="server" class="notification-badge-main" style="display: none;">0</span>
                                </button>
                                <!-- Notification Dropdown -->
                                <div id="notificationDropdown" class="notification-dropdown">
                                    <div class="notification-header">
                                        <h6 class="marathi-font mb-0">Notifications</h6>
                                        <button id="btnMarkAllRead" class="btn btn-sm marathi-font" style="background: rgba(255,255,255,0.1); color: white; border: none;">Mark All Read</button>
                                    </div>
                                    <div id="notificationList" class="notification-list">
                                        <!-- Notifications will be loaded here -->
                                    </div>
                                    <div class="notification-footer">
                                        <a href="Notifications.aspx" class="marathi-font" style="color: white; text-decoration: none;">View All Notifications</a>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label>
                                <span id="membershipBadge" runat="server" class="membership-status membership-free">Free</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Membership Status & Limits -->
                        <asp:Panel ID="pnlMembershipInfo" runat="server" CssClass="membership-limits">
                            <h6 class="marathi-font text-center mb-3" style="color: white;">📊 Daily Limits</h6>
                            <div class="limit-item marathi-font">
                                <span>Messages Remaining:</span>
                                <span id="remainingMessages" runat="server">5</span>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Interests Remaining:</span>
                                <span id="remainingInterests" runat="server">2</span>
                            </div>
                            <div class="limit-item marathi-font">
                                <span>Profile Views:</span>
                                <span>Unlimited</span>
                            </div>
                        </asp:Panel>

                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Upgrade Prompt for Free Users -->
                    <asp:Panel ID="pnlUpgradePrompt" runat="server" CssClass="upgrade-prompt" Visible="false">
                        <h6 class="marathi-font" style="color: white; margin-bottom: 10px;">🚀 Upgrade Your Experience!</h6>
                        <p class="marathi-font small" style="color: rgba(255,255,255,0.8); margin-bottom: 15px;">
                            Get unlimited messages, interests, and premium features
                        </p>
                        <a href="Membership.aspx" class="upgrade-btn marathi-font">
                            ⭐ Upgrade Now
                        </a>
                    </asp:Panel>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <span id="interestNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <span id="messageNotification" runat="server" class="notification-badge" style="display: none;">0</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium Membership</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest with Block Check and Membership Limit Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining interests
            const remainingInterests = parseInt(document.getElementById('<%= remainingInterests.ClientID %>').innerText);
            if (remainingInterests <= 0) {
                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function (isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;

                                // Update remaining interests count
                                const remainingElement = document.getElementById('<%= remainingInterests.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily interest limit reached! Upgrade to send more interests.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check and Membership Limit Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // Check remaining messages
            const remainingMessages = parseInt(document.getElementById('<%= remainingMessages.ClientID %>').innerText);
            if (remainingMessages <= 0) {
                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                return;
            }

            // First check if user is blocked
            checkIfBlocked(toUserID, function(isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                
                                // Update remaining messages count
                                const remainingElement = document.getElementById('<%= remainingMessages.ClientID %>');
                                remainingElement.innerText = parseInt(remainingElement.innerText) - 1;
                                
                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else if (response.d === "limit_reached") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Daily message limit reached! Upgrade to send more messages.', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

        // Notification Functions
        function initializeNotifications() {
            loadNotifications();
            setInterval(loadNotifications, 30000); // Refresh every 30 seconds
            
            // Notification bell click event
            $('#btnNotificationBell').click(function(e) {
                e.stopPropagation();
                $('#notificationDropdown').toggle();
            });
            
            // Mark all as read
            $('#btnMarkAllRead').click(function() {
                markAllNotificationsAsRead();
            });
            
            // Close dropdown when clicking outside
            $(document).click(function() {
                $('#notificationDropdown').hide();
            });
        }

        function loadNotifications() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetNotifications",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        const data = JSON.parse(response.d);
                        updateNotificationUI(data);
                    }
                },
                error: function () {
                    console.log('Error loading notifications');
                }
            });
        }

        function updateNotificationUI(data) {
            // Update badge counts
            if (data.TotalUnread > 0) {
                $('#<%= totalNotificationBadge.ClientID %>').text(data.TotalUnread).show();
            } else {
                $('#<%= totalNotificationBadge.ClientID %>').hide();
            }
            
            if (data.UnreadInterests > 0) {
                $('#<%= interestNotification.ClientID %>').text(data.UnreadInterests).show();
            } else {
                $('#<%= interestNotification.ClientID %>').hide();
            }
            
            if (data.UnreadMessages > 0) {
                $('#<%= messageNotification.ClientID %>').text(data.UnreadMessages).show();
            } else {
                $('#<%= messageNotification.ClientID %>').hide();
            }
            
            // Update notification list
            const notificationList = $('#notificationList');
            notificationList.empty();
            
            if (data.Notifications.length === 0) {
                notificationList.append('<div class="notification-item"><div class="notification-content">No new notifications</div></div>');
            } else {
                data.Notifications.forEach(notification => {
                    const notificationItem = $(`
                        <div class="notification-item ${notification.IsRead ? 'read' : 'unread'}" data-id="${notification.NotificationID}">
                            <div class="notification-content">${notification.Message}</div>
                            <div class="notification-time">${notification.TimeAgo}</div>
                        </div>
                    `);
                    
                    notificationItem.click(function() {
                        markNotificationAsRead(notification.NotificationID);
                        handleNotificationClick(notification);
                    });
                    
                    notificationList.append(notificationItem);
                });
            }
        }

        function markNotificationAsRead(notificationID) {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkNotificationAsRead",
                data: JSON.stringify({
                    notificationID: notificationID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        // Remove the unread style
                        $(`.notification-item[data-id="${notificationID}"]`).removeClass('unread').addClass('read');
                        loadNotifications(); // Refresh counts
                    }
                }
            });
        }

        function markAllNotificationsAsRead() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkAllNotificationsAsRead",
                data: JSON.stringify({
                    userID: parseInt(currentUserID)
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        loadNotifications();
                        showNotification('All notifications marked as read!', 'success');
                    }
                }
            });
        }

        function handleNotificationClick(notification) {
            // Handle navigation based on notification type
            switch (notification.Type) {
                case 'Interest':
                    window.location.href = 'Interests.aspx';
                    break;
                case 'Message':
                    window.location.href = 'Messages.aspx';
                    break;
                case 'ProfileView':
                    window.location.href = 'ProfileViews.aspx';
                    break;
                default:
                    // Do nothing
                    break;
            }

            // Close dropdown
            $('#notificationDropdown').hide();
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            initializeNotifications();
            console.log('Dashboard loaded successfully');
        });
    </script>
</asp:Content>--%>


















<%--<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.1) 100%);
            color: white;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%);
            z-index: 1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 25px;
            margin-top: 20px;
            position: relative;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 25px;
            height: fit-content;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 25px;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
        }
        
        .user-photo-large {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .user-photo-large:hover {
            transform: scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .user-name {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .user-details {
            color: rgba(255,255,255,0.8);
            font-size: 0.9rem;
            line-height: 1.5;
            background: rgba(255,255,255,0.1);
            padding: 12px;
            border-radius: 12px;
            margin: 10px 0;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 20px 0;
        }
        
        .stat-box {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .stat-number {
            display: block;
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 25px 0;
            position: relative;
            z-index: 2;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        
        .nav-item:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
            color: white;
        }
        
        .nav-item:hover::before {
            left: 100%;
        }
        
        .nav-item.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: rgba(255,255,255,0.3);
        }
        
        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        
        .section-title {
            color: white;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 15px;
            margin-bottom: 25px;
            font-size: 1.6rem;
            font-weight: bold;
            position: relative;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 80px;
            height: 2px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 2px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .profile-header-large {
            position: relative;
            height: 180px;
            overflow: hidden;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -60px;
            left: 50%;
            transform: translateX(-50%);
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.05);
            border-color: rgba(255,255,255,0.5);
        }
        
        .online-indicator {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.8);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 10;
            box-shadow: 0 2px 8px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 80px 20px 20px;
            text-align: center;
            background: transparent;
        }
        
        .profile-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            margin-bottom: 8px;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-age {
            color: rgba(255,255,255,0.9);
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.9rem;
        }
        
        .profile-location {
            color: rgba(255,255,255,0.8);
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        
        .profile-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 12px;
        }
        
        .btn-action {
            padding: 10px 16px;
            border: none;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            max-width: 110px;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }
        
        .btn-interest {
            background: rgba(214, 51, 132, 0.8);
            color: white;
            border: 1px solid rgba(214, 51, 132, 0.5);
        }
        
        .btn-message {
            background: rgba(102, 126, 234, 0.8);
            color: white;
            border: 1px solid rgba(102, 126, 234, 0.5);
        }

        .btn-shortlist {
            background: rgba(255, 215, 0, 0.8);
            color: white;
            border: 1px solid rgba(255, 215, 0, 0.5);
        }

        /* Block & Report Button Styles */
        .btn-block {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.5);
        }

        .btn-report {
            background: rgba(253, 126, 20, 0.8);
            color: white;
            border: 1px solid rgba(253, 126, 20, 0.5);
        }

        .block-report-actions {
            display: flex;
            gap: 6px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .btn-block-report {
            padding: 6px 10px;
            border: none;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .btn-block-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .empty-state {
            text-align: center;
            padding: 60px 25px;
            color: rgba(255,255,255,0.7);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 20px;
            border: 2px dashed rgba(255,255,255,0.1);
        }
        
        .filter-section {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 18px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }
        
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .stat-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 18px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-3px);
        }
        
        .stat-card .h4 {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 6px;
            color: white;
            text-shadow: 0 2px 5px rgba(0,0,0,0.3);
        }
        
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 18px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 15px;
            padding: 18px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
        }

        .profile-view-card:hover {
            background: rgba(255, 255, 255, 0.12);
            transform: translateY(-3px);
        }

        .viewer-img-large {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
        }

        .viewer-img-large:hover {
            transform: scale(1.1);
            border-color: rgba(255,255,255,0.5);
        }

        .logout-btn {
            width: 100%;
            padding: 12px;
            background: rgba(108, 117, 125, 0.8);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            font-size: 0.9rem;
            backdrop-filter: blur(5px);
            color: white;
        }
        
        .filter-control:focus {
            border-color: rgba(102, 126, 234, 0.8);
            background: rgba(255,255,255,0.15);
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .filter-control::placeholder {
            color: rgba(255,255,255,0.6);
        }
        
        .btn-primary {
            background: rgba(102, 126, 234, 0.8);
            border: 1px solid rgba(102, 126, 234, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background: rgba(102, 126, 234, 0.9);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            border: 1px solid rgba(108, 117, 125, 0.5);
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.9);
            transform: translateY(-2px);
        }

        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .left-sidebar {
                padding: 20px;
            }
        }
    </style>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner glass-effect">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="color: white; margin-bottom: 10px;">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0" style="color: rgba(255,255,255,0.9);">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge marathi-font p-2" style="background: rgba(255,255,255,0.2); color: white; border: 1px solid rgba(255,255,255,0.3);">⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar -->
                <div class="left-sidebar glass-effect">
                    <div class="user-profile-card">
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                        </a>
                        <a class="nav-item" href="BlockedUsers.aspx">
                            <i class="fas fa-ban"></i>
                            <span class="marathi-font">Blocked Users</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content -->
                <div class="right-content glass-effect">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small" style="color: rgba(255,255,255,0.8);">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: white;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Min" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Max" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="filter-label marathi-font" style="color: rgba(255,255,255,0.9); margin-bottom: 8px;">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2 ml-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart" style="color: #ff6b6b;"></i> 
                            Recommended Profiles for You
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large">
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                            
                                            <!-- Block & Report Buttons -->
                                            <div class="block-report-actions">
                                                <button class="btn-block-report btn-block marathi-font" 
                                                    onclick='blockUser(event, <%# Eval("UserID") %>)'>
                                                    🚫 Block
                                                </button>
                                                <button class="btn-block-report btn-report marathi-font" 
                                                    onclick='reportUser(event, <%# Eval("UserID") %>)'>
                                                    ⚠ Report
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-3x mb-3"></i>
                            <h4 class="marathi-font">No profiles found yet</h4>
                            <p class="marathi-font">Please modify your search criteria or check back later</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest with Block Check
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // First check if user is blocked
            checkIfBlocked(toUserID, function(isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send interest to a blocked user!', 'error');
                    return;
                }

                if (confirm('Are you interested in this profile?')) {
                    const button = event.target.closest('.btn-interest') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendInterest",
                        data: JSON.stringify({
                            sentByUserID: parseInt(currentUserID),
                            targetUserID: toUserID
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Interest Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                showNotification('Interest sent successfully!', 'success');
                            } else if (response.d === "exists") {
                                button.innerHTML = '✅ Already Sent';
                                button.style.background = 'rgba(255, 193, 7, 0.8)';
                                button.disabled = true;
                                showNotification('You have already sent interest to this profile!', 'info');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send interest to blocked user!', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending interest!', 'error');
                        }
                    });
                }
            });
        }

        // Send Message with Block Check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            // First check if user is blocked
            checkIfBlocked(toUserID, function(isBlocked) {
                if (isBlocked) {
                    showNotification('You cannot send message to a blocked user!', 'error');
                    return;
                }

                const message = prompt('Enter your message:');
                if (message) {
                    const button = event.target.closest('.btn-message') || event.target;
                    const originalText = button.innerHTML;
                    button.innerHTML = '⏳ Sending...';
                    button.disabled = true;

                    const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/SendMessage",
                        data: JSON.stringify({
                            fromUserID: parseInt(currentUserID),
                            toUserID: toUserID,
                            messageText: message
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "success") {
                                button.innerHTML = '✅ Message Sent';
                                button.style.background = 'rgba(40, 167, 69, 0.8)';
                                button.disabled = true;
                                showNotification('Message sent successfully!', 'success');
                            } else if (response.d === "blocked") {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Cannot send message to blocked user!', 'error');
                            } else {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending message!', 'error');
                            }
                        },
                        error: function () {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    });
                }
            });
        }

        // Check if user is blocked
        function checkIfBlocked(targetUserID, callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CheckIfBlocked",
                data: JSON.stringify({
                    currentUserID: parseInt(currentUserID),
                    targetUserID: targetUserID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(false);
                }
            });
        }

        // Shortlist Profile
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = 'rgba(40, 167, 69, 0.8)';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = 'rgba(255, 193, 7, 0.8)';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Block User Function
        function blockUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you sure you want to block this user? You will no longer see their profile and they cannot contact you.')) {
                const button = event.target.closest('.btn-block') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Blocking...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/BlockUser",
                    data: JSON.stringify({
                        blockedByUserID: parseInt(currentUserID),
                        blockedUserID: userID
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User blocked successfully!', 'success');
                            
                            // Remove the profile card from view
                            setTimeout(() => {
                                const profileCard = event.target.closest('.profile-card');
                                if (profileCard) {
                                    profileCard.style.opacity = '0.5';
                                    profileCard.style.pointerEvents = 'none';
                                }
                            }, 1000);
                        } else if (response.d === "exists") {
                            button.innerHTML = '✅ Already Blocked';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('You have already blocked this user!', 'info');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error blocking user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error blocking user!', 'error');
                    }
                });
            }
        }

        // Report User Function
        function reportUser(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const reportReason = prompt('Please specify the reason for reporting this profile:');
            if (reportReason) {
                const button = event.target.closest('.btn-report') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Reporting...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/ReportUser",
                    data: JSON.stringify({
                        reportedByUserID: parseInt(currentUserID),
                        reportedUserID: userID,
                        reportReason: reportReason
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Reported';
                            button.style.background = 'rgba(108, 117, 125, 0.8)';
                            button.disabled = true;
                            showNotification('User reported successfully! Our team will review this profile.', 'success');
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error reporting user!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error reporting user!', 'error');
                    }
                });
            }
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '15px 20px';
            notification.style.borderRadius = '10px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 5px 15px rgba(0,0,0,0.3)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';

            if (type === 'success') {
                notification.style.background = 'rgba(40, 167, 69, 0.8)';
            } else if (type === 'error') {
                notification.style.background = 'rgba(220, 53, 69, 0.8)';
            } else if (type === 'info') {
                notification.style.background = 'rgba(23, 162, 184, 0.8)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                if (document.body.contains(notification)) {
                    document.body.removeChild(notification);
                }
            }, 3000);
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            console.log('Dashboard loaded successfully');
        });
    </script>
</asp:Content>--%>





















<%--

<%@ Page Title="Marathi Matrimony - Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="JivanBandhan4.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }
        
        .dashboard-container {
            background: linear-gradient(135deg, #f8f9ff 0%, #eef2ff 50%, #f0f4ff 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .dashboard-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 300px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            clip-path: polygon(0 0, 100% 0, 100% 70%, 0 100%);
            z-index: 0;
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            color: #2c3e50;
            border-radius: 25px;
            padding: 35px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.2);
            z-index: 1;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0.3;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .left-sidebar {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .left-sidebar::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0.2;
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        
        .user-photo-large {
            width: 240px;
            height: 240px;
            border-radius: 50%;
            object-fit: cover;
            border: 10px solid rgba(255,255,255,0.8);
            margin: 0 auto 25px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 5px;
        }
        
        .user-photo-large:hover {
            transform: scale(1.1);
            border-color: #d63384;
            box-shadow: 0 25px 60px rgba(214, 51, 132, 0.4);
        }
        
        .user-name {
            font-size: 1.6rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 12px;
        }
        
        .user-details {
            color: #6c757d;
            font-size: 1rem;
            line-height: 1.5;
            background: rgba(248,249,250,0.7);
            padding: 12px;
            border-radius: 15px;
            margin: 10px 0;
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 25px 0;
        }
        
        .stat-box {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(5px);
        }
        
        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .stat-number {
            display: block;
            font-size: 1.8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .nav-menu {
            margin: 30px 0;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 18px;
            margin: 10px 0;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #495057;
            text-decoration: none;
            background: rgba(248,249,250,0.6);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
            overflow: hidden;
        }
        
        .nav-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: left 0.3s ease;
            z-index: -1;
        }
        
        .nav-item:hover {
            color: white;
            transform: translateX(8px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .nav-item:hover::before {
            left: 0;
        }
        
        .nav-item.active {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.4);
            transform: translateX(5px);
        }
        
        .nav-item i {
            margin-right: 60px;
            width: 20px;
            text-align: center;
            font-size: 1.2rem;
        }
        
        .right-content {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%);
            backdrop-filter: blur(10px);
            border-radius: 25px;
            padding: 35px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }
        
        .right-content::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0.2;
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 18px;
            margin-bottom: 30px;
            font-size: 2rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 100px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 25px;
        }
        
        .profile-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            border-radius: 25px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
        }
        
        .profile-card::before {
            content: '';
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #d63384);
            border-radius: 27px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .profile-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 60px rgba(0,0,0,0.2);
        }
        
        .profile-card:hover::before {
            opacity: 0.3;
        }
        
        .profile-header-large {
            position: relative;
            height: 220px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .profile-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.8;
            transition: transform 0.4s ease;
        }
        
        .profile-card:hover .profile-bg {
            transform: scale(1.1);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -80px;
            left: 50%;
            transform: translateX(-50%);
            width: 280px;
            height: 280px;
            border-radius: 50%;
            border: 8px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.12);
            border-color: #d63384;
            box-shadow: 0 25px 60px rgba(214, 51, 132, 0.4);
        }
        
        .profile-main-photo-large {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        .profile-card:hover .profile-main-photo-large {
            transform: scale(1.08);
        }
        
        .online-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            border: 3px solid white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .online {
            background: #51cf66;
            animation: pulse-online 2s infinite;
        }
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .profile-content-large {
            padding: 150px 25px 25px;
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
        }
        
        .profile-name {
            font-size: 1.4rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        
        .profile-age {
            color: #d63384;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        
        .profile-location {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .profile-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin-bottom: 25px;
        }
        
        .tag {
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #495057;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
        }
        
        .tag:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .profile-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            max-width: 140px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s ease;
        }
        
        .btn-action:hover::before {
            left: 100%;
        }
        
        .btn-interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(214, 51, 132, 0.4);
        }
        
        .btn-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 30px;
            color: #6c757d;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            border-radius: 25px;
            border: 2px dashed rgba(108, 117, 125, 0.3);
        }
        
        .empty-state i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
        }
        
        .membership-banner {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 1px solid rgba(255, 234, 167, 0.8);
            border-radius: 20px;
            padding: 20px;
            text-align: center;
            margin: 25px 0;
            box-shadow: 0 5px 20px rgba(255, 193, 7, 0.2);
            position: relative;
            overflow: hidden;
        }
        
        .membership-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.3), transparent);
            transform: rotate(45deg);
            animation: shine 3s infinite;
        }
        
        @keyframes shine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }
        
        .premium-features {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 1px solid rgba(195, 230, 203, 0.8);
            border-radius: 20px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.2);
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            padding: 8px 0;
            font-size: 0.9rem;
            color: #155724;
        }
        
        .feature-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }
        
        .premium-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 20px 0;
        }
        
        .stat-box.premium {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 1px solid rgba(255, 234, 167, 0.8);
        }
        
        .membership-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            margin-left: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        
        .badge-free {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        
        .badge-silver {
            background: linear-gradient(135deg, #c0c0c0 0%, #a8a8a8 100%);
            color: white;
        }
        
        .badge-gold {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }
        
        .badge-platinum {
            background: linear-gradient(135deg, #e5e4e2 0%, #b4b4b4 100%);
            color: #333;
        }
        
        .logout-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            border-radius: 15px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .logout-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }
        
        .logout-btn:hover::before {
            left: 100%;
        }
        
        .logout-btn:hover {
            background: linear-gradient(135deg, #495057 0%, #343a40 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.5);
        }
        
        .filter-section {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin-bottom: 20px;
        }
        
        .filter-group {
            margin-bottom: 20px;
        }
        
        .filter-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 12px;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid rgba(233, 236, 239, 0.8);
            border-radius: 12px;
            background: rgba(255,255,255,0.8);
            transition: all 0.3s ease;
            font-size: 0.95rem;
            backdrop-filter: blur(5px);
        }
        
        .filter-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.15);
            background: rgba(255,255,255,0.95);
        }

        /* Profile Views Styles */
        .profile-views-container {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid rgba(233, 236, 239, 0.8);
            border-radius: 20px;
            padding: 20px;
            background: linear-gradient(135deg, rgba(248,249,250,0.8) 0%, rgba(233,236,239,0.6) 100%);
            backdrop-filter: blur(5px);
        }

        .profile-view-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.9) 0%, rgba(248,249,250,0.8) 100%);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
        }

        .profile-view-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border-color: #667eea;
        }

        .viewer-info {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .viewer-photo {
            margin-right: 20px;
        }

        .viewer-img-large {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 6px solid rgba(255,255,255,0.8);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 12px 35px rgba(0,0,0,0.2);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }

        .viewer-img-large:hover {
            transform: scale(1.15);
            border-color: #667eea;
            box-shadow: 0 18px 45px rgba(102, 126, 234, 0.5);
        }

        .viewer-details {
            flex: 1;
        }

        .viewer-name {
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.2rem;
            margin-bottom: 8px;
        }

        .viewer-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 8px;
        }

        .view-date, .view-count {
            font-size: 0.9rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .viewer-location {
            font-size: 0.95rem;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-header {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            padding: 20px 25px;
            border-radius: 20px;
            border: 1px solid rgba(233, 236, 239, 0.8);
            margin-bottom: 25px;
            backdrop-filter: blur(5px);
        }

        .remaining-counts {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border: 1px solid rgba(144, 202, 249, 0.8);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 5px 20px rgba(25, 118, 210, 0.2);
        }
        
        .remaining-count-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid rgba(227, 242, 253, 0.8);
        }
        
        .remaining-count-item:last-child {
            border-bottom: none;
        }
        
        .count-value {
            font-weight: bold;
            color: #1976d2;
            font-size: 1.2rem;
        }
        
        /* Quick Stats Header */
        .quick-stats-header {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .stat-card .h4 {
            font-size: 2.2rem;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .stat-card .text-primary { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stat-card .text-success { background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stat-card .text-warning { background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stat-card .text-info { background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

        /* Badge Notification Styles */
        .nav-badge {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 20px;
            padding: 4px 8px;
            min-width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(214, 51, 132, 0.4);
            animation: badge-appear 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 2px solid white;
        }

        .badge-count {
            color: white;
            font-weight: bold;
            font-size: 0.75rem;
            line-height: 1;
        }

        /* Pulse animation for important notifications */
        .nav-badge.pulse {
            animation: badge-pulse 2s infinite;
        }

        @keyframes badge-pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(255, 107, 107, 0.7);
                transform: translateY(-50%) scale(1);
            }
            50% {
                transform: translateY(-50%) scale(1.1);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(255, 107, 107, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(255, 107, 107, 0);
                transform: translateY(-50%) scale(1);
            }
        }

        @keyframes badge-appear {
            0% {
                transform: translateY(-50%) scale(0);
                opacity: 0;
            }
            70% {
                transform: translateY(-50%) scale(1.2);
            }
            100% {
                transform: translateY(-50%) scale(1);
                opacity: 1;
            }
        }

        /* Notification Panel Styles */
        .notification-panel {
            position: fixed;
            top: 20px;
            right: 20px;
            width: 350px;
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            z-index: 10000;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transform: translateX(400px);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .notification-panel.show {
            transform: translateX(0);
        }

        .notification-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h5 {
            margin: 0;
            font-weight: bold;
        }

        .notification-close {
            background: none;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 5px;
        }

        .notification-content {
            max-height: 400px;
            overflow-y: auto;
            padding: 0;
        }

        .notification-item {
            padding: 15px 20px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .notification-item:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-item.unread {
            background: rgba(214, 51, 132, 0.1);
            border-left: 4px solid #d63384;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .notification-icon.message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .notification-icon.interest {
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            color: white;
        }

        .notification-icon.shortlist {
            background: linear-gradient(135deg, #ffd700 0%, #ffa500 100%);
            color: white;
        }

        .notification-details {
            flex: 1;
        }

        .notification-text {
            font-size: 0.9rem;
            margin-bottom: 4px;
            color: #495057;
        }

        .notification-time {
            font-size: 0.75rem;
            color: #6c757d;
        }

        /* Real-time Notification Bell */
        .notification-bell {
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            z-index: 9999;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 3px solid white;
        }

        .notification-bell:hover {
            transform: scale(1.1) rotate(15deg);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.6);
        }

        .notification-bell.has-notifications::after {
            content: '';
            position: absolute;
            top: 8px;
            right: 8px;
            width: 12px;
            height: 12px;
            background: linear-gradient(135deg, #ff6b6b 0%, #d63384 100%);
            border-radius: 50%;
            border: 2px solid white;
            animation: bell-pulse 2s infinite;
        }

        @keyframes bell-pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        /* High Quality Photo Styles */
        .user-photo-large.high-quality,
        .profile-main-photo-large.high-quality,
        .viewer-img-large.high-quality {
            image-rendering: -webkit-optimize-contrast;
            image-rendering: crisp-edges;
            image-rendering: high-quality;
        }
        
        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 280px 1fr;
                gap: 20px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 25px;
            }

            .profile-photo-container-large {
                width: 240px;
                height: 240px;
                bottom: -70px;
            }
            
            .profile-content-large {
                padding: 130px 20px 20px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .quick-stats-header {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
            
            .user-photo-large {
                width: 200px;
                height: 200px;
            }
            
            .profile-photo-container-large {
                width: 200px;
                height: 200px;
                bottom: -60px;
            }
            
            .profile-content-large {
                padding: 110px 20px 20px;
            }
            
            .viewer-img-large {
                width: 120px;
                height: 120px;
            }
            
            .premium-stats {
                grid-template-columns: 1fr;
            }

            .notification-panel {
                width: 300px;
                right: 10px;
            }
            
            .nav-badge {
                right: 15px;
            }
        }
        
        @media (max-width: 768px) {
            .quick-stats-header {
                grid-template-columns: 1fr;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .user-photo-large {
                width: 180px;
                height: 180px;
            }
            
            .profile-photo-container-large {
                width: 180px;
                height: 180px;
                bottom: -50px;
            }
            
            .profile-content-large {
                padding: 100px 15px 15px;
            }
            
            .viewer-img-large {
                width: 100px;
                height: 100px;
            }
            
            .welcome-banner {
                padding: 25px;
            }
            
            .right-content {
                padding: 25px;
            }
        }
        
        @media (max-width: 576px) {
            .profile-actions {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn-action {
                max-width: 100%;
            }
            
            .viewer-info {
                flex-direction: column;
                text-align: center;
            }
            
            .viewer-photo {
                margin-right: 0;
                margin-bottom: 15px;
            }
            
            .viewer-stats {
                justify-content: center;
            }

            .profile-photo-container-large {
                width: 160px;
                height: 160px;
                bottom: -45px;
            }
            
            .profile-content-large {
                padding: 90px 15px 15px;
            }
            
            .user-photo-large {
                width: 160px;
                height: 160px;
            }
            
            .viewer-img-large {
                width: 90px;
                height: 90px;
            }
        }
    </style>


    <div class="container mt-4">
        <h1><asp:Literal ID="litPageTitle" runat="server" Text="Welcome to JivanBandhan"></asp:Literal></h1>
        <p><asp:Literal ID="litPageDescription" runat="server" Text="Find your perfect life partner..."></asp:Literal></p>
        
        <!-- Dynamic content साठी Literal controls वापरा -->
    </div>

    <div class="dashboard-container">
        <div class="container">
            <!-- Welcome Banner -->
            <div class="welcome-banner">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font">Welcome, <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>!</h1>
                        <p class="marathi-font mb-0">We are with you in your journey to find your ideal partner</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge bg-light text-dark marathi-font p-2">📅 Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></span>
                            <span class="badge bg-light text-dark marathi-font p-2">⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free"></asp:Label></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout -->
            <div class="main-layout">
                <!-- Left Sidebar - Current User Profile -->
                <div class="left-sidebar">
                    <div class="user-profile-card">
                        <!-- Large Profile Photo -->
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Quick Stats -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblProfileViews" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Views</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsReceived" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Interests</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblInterestsSent" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Sent</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMessages" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Messages</span>
                            </div>
                        </div>
                        
                        <!-- Remaining Counts for Free Users -->
                        <asp:Panel ID="pnlRemainingCounts" runat="server" CssClass="remaining-counts" Visible="false">
                            <h6 class="marathi-font text-center mb-3">📊 Daily Remaining Limits</h6>
                            <div class="remaining-count-item marathi-font">
                                <span>💌 Messages:</span>
                                <span class="count-value" id="remainingMessagesCount">0</span>
                            </div>
                            <div class="remaining-count-item marathi-font">
                                <span>💝 Interests:</span>
                                <span class="count-value" id="remainingInterestsCount">0</span>
                            </div>
                        </asp:Panel>
                        
                        <!-- Premium Usage Stats -->
                        <asp:Panel ID="pnlPremiumStats" runat="server" CssClass="premium-stats" Visible="false">
                            <div class="stat-box premium">
                                <span class="stat-number"><asp:Label ID="lblRemainingMessages" runat="server" Text="∞"></asp:Label></span>
                                <span class="stat-label marathi-font">Remaining Messages</span>
                            </div>
                            <div class="stat-box premium">
                                <span class="stat-number"><asp:Label ID="lblRemainingInterests" runat="server" Text="∞"></asp:Label></span>
                                <span class="stat-label marathi-font">Remaining Interests</span>
                            </div>
                        </asp:Panel>
                        
                        <!-- Membership Status -->
                        <asp:Panel ID="pnlMembership" runat="server" CssClass="membership-banner">
                            <h6 class="marathi-font mb-2">
                                <asp:Label ID="lblMembershipType" runat="server" Text="Free Member"></asp:Label>
                                <asp:Label ID="lblMembershipExpiry" runat="server" CssClass="small text-muted d-block" 
                                    Text=""></asp:Label>
                            </h6>
                            <asp:Button ID="btnUpgradeMembership" runat="server" Text="⭐ Upgrade to Premium" 
                                CssClass="btn btn-warning btn-sm marathi-font" OnClick="btnUpgradeMembership_Click" />
                        </asp:Panel>

                        <!-- Premium Features Status -->
                        <asp:Panel ID="pnlPremiumFeatures" runat="server" CssClass="mt-3" Visible="false">
                            <div class="premium-features">
                                <h6 class="marathi-font text-success mb-2">✅ Premium Features</h6>
                                <div class="feature-list small">
                                    <div class="feature-item marathi-font">
                                        <i class="fas fa-check text-success"></i>
                                        Unlimited Messages
                                    </div>
                                    <div class="feature-item marathi-font">
                                        <i class="fas fa-check text-success"></i>
                                        Priority Visibility
                                    </div>
                                    <div class="feature-item marathi-font">
                                        <i class="fas fa-check text-success"></i>
                                        Advanced Search
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                    
                    <!-- Navigation Menu with Badges -->
                    <div class="nav-menu">
                        <a class="nav-item active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                            <asp:Panel ID="pnlDashboardBadge" runat="server" CssClass="nav-badge" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblDashboardCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                            <asp:Panel ID="pnlProfileBadge" runat="server" CssClass="nav-badge" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblProfileCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                            <asp:Panel ID="pnlMatchesBadge" runat="server" CssClass="nav-badge" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblMatchesCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="Interests.aspx">
                            <i class="fas fa-star"></i>
                            <span class="marathi-font">Interests</span>
                            <asp:Panel ID="pnlInterestsBadge" runat="server" CssClass="nav-badge pulse" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblInterestsCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="Messages.aspx">
                            <i class="fas fa-comments"></i>
                            <span class="marathi-font">Messages</span>
                            <asp:Panel ID="pnlMessagesBadge" runat="server" CssClass="nav-badge pulse" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblMessagesCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="Shortlisted.aspx">
                            <i class="fas fa-bookmark"></i>
                            <span class="marathi-font">Shortlisted</span>
                            <asp:Panel ID="pnlShortlistedBadge" runat="server" CssClass="nav-badge" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblShortlistedCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
                        </a>
                        <a class="nav-item" href="Membership.aspx">
                            <i class="fas fa-crown"></i>
                            <span class="marathi-font">Premium</span>
                        </a>
                        <a class="nav-item" href="Settings.aspx">
                            <i class="fas fa-cog"></i>
                            <span class="marathi-font">Settings</span>
                        </a>
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content - Main Content -->
                <div class="right-content">
                    <!-- Quick Stats Header -->
                    <div class="quick-stats-header">
                        <div class="stat-card">
                            <div class="h4 text-primary mb-1"><asp:Label ID="lblTotalViews" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 text-success mb-1"><asp:Label ID="lblTotalInterests" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small">Total Interests</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 text-warning mb-1"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small">Today's Matches</div>
                        </div>
                        <div class="stat-card">
                            <div class="h4 text-info mb-1"><asp:Label ID="lblNewMessages" runat="server" Text="0"></asp:Label></div>
                            <div class="marathi-font small">New Messages</div>
                        </div>
                    </div>

                    <!-- Filters Section -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: #8B0000;">
                            <i class="fas fa-filter"></i> Search Profiles
                        </h5>
                        <div class="filter-row">
                            <div class="filter-group">
                                <div class="filter-label marathi-font">Age Range</div>
                                <div class="d-flex gap-2">
                                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="filter-control" 
                                        placeholder="Minimum" TextMode="Number"></asp:TextBox>
                                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="filter-control" 
                                        placeholder="Maximum" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font">Height</div>
                                <asp:DropDownList ID="ddlHeight" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Heights</asp:ListItem>
                                    <asp:ListItem Value="5'0&quot;">5'0"</asp:ListItem>
                                    <asp:ListItem Value="5'2&quot;">5'2"</asp:ListItem>
                                    <asp:ListItem Value="5'4&quot;">5'4"</asp:ListItem>
                                    <asp:ListItem Value="5'6&quot;">5'6"</asp:ListItem>
                                    <asp:ListItem Value="5'8&quot;">5'8"</asp:ListItem>
                                    <asp:ListItem Value="6'0&quot;">6'0"</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font">Education</div>
                                <asp:DropDownList ID="ddlEducation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Education</asp:ListItem>
                                    <asp:ListItem Value="Graduate">Graduate</asp:ListItem>
                                    <asp:ListItem Value="Post Graduate">Post Graduate</asp:ListItem>
                                    <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                                    <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="filter-row">
                            <div class="filter-group">
                                <div class="filter-label marathi-font">City</div>
                                <asp:DropDownList ID="ddlCity" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Cities</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font">Occupation</div>
                                <asp:DropDownList ID="ddlOccupation" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All Occupations</asp:ListItem>
                                    <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                                    <asp:ListItem Value="Engineer">Engineer</asp:ListItem>
                                    <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                                    <asp:ListItem Value="Government Job">Government Job</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font">Manglik</div>
                                <asp:DropDownList ID="ddlManglik" runat="server" CssClass="filter-control">
                                    <asp:ListItem Value="">All</asp:ListItem>
                                    <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                    <asp:ListItem Value="No">No</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" 
                                CssClass="btn btn-primary marathi-font px-4 py-2" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="🔄 Reset" 
                                CssClass="btn btn-secondary marathi-font px-4 py-2" OnClick="btnReset_Click" />
                        </div>
                    </div>
                    
                    <!-- Recommended Profiles Section -->
                    <div class="matches-section">
                        <h3 class="section-title marathi-font">
                            <i class="fas fa-heart text-danger"></i> 
                            Recommended Profiles for You
                            <small class="text-muted marathi-font" style="font-size: 1rem;">
                                (<asp:Label ID="lblRecommendationInfo" runat="server" Text=""></asp:Label>)
                            </small>
                        </h3>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptProfiles" runat="server" OnItemDataBound="rptProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large">
                                            <!-- GetProfileBackground inline implementation -->
                                            <img src='<%# Eval("Gender").ToString() == "Female" ? "~/Images/female-bg.jpg" : "~/Images/male-bg.jpg" %>' 
                                                 class="profile-bg" alt="background" />
                                            
                                            <!-- Large Profile Photo -->
                                            <div class="profile-photo-container-large">
                                                <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("UserID") + "/profile.jpg" %>' 
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>" 
                                                title='<%# (new Random().Next(0,100) > 50 ? "Online" : "Offline") %>'></div>
                                            <div class="premium-badge" id="premiumBadge" runat="server" 
                                                style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                ⭐ Premium
                                            </div>
                                        </div>
                                        <div class="profile-content-large">
                                            <div class="profile-name marathi-font">
                                                <%# Eval("FullName") %>
                                            </div>
                                            <div class="profile-age marathi-font">
                                                <!-- CalculateAge inline implementation -->
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt text-muted"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            <div class="profile-tags">
                                                <span class="tag marathi-font"><%# Eval("Education") %></span>
                                                <span class="tag marathi-font"><%# Eval("Caste") %></span>
                                                <span class="tag marathi-font"><%# Eval("Religion") %></span>
                                            </div>
                                            <div class="profile-actions">
                                                <button class="btn-action btn-interest marathi-font" 
                                                    onclick='sendInterest(event, <%# Eval("UserID") %>)'>
                                                    💝 Interest
                                                </button>
                                                <button class="btn-action btn-message marathi-font"
                                                    onclick='sendMessage(event, <%# Eval("UserID") %>)'>
                                                    💌 Message
                                                </button>
                                                <button class="btn-action btn-shortlist marathi-font" 
                                                    onclick='shortlistProfile(event, <%# Eval("UserID") %>)'>
                                                    ⭐ Shortlist
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoProfiles" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users fa-4x text-muted mb-3"></i>
                            <h4 class="marathi-font text-muted">No profiles found yet</h4>
                            <p class="marathi-font text-muted">Please modify your search criteria or check back later</p>
                            <asp:Button ID="btnRefresh" runat="server" Text="🔄 Refresh" 
                                CssClass="btn btn-primary marathi-font mt-3 px-4 py-2" OnClick="btnRefresh_Click" />
                        </asp:Panel>

                        <!-- Load More Button -->
                        <div class="text-center mt-4" id="pnlLoadMore" runat="server" visible="false">
                            <asp:Button ID="btnLoadMore" runat="server" Text="📥 Load More Profiles" 
                                CssClass="btn btn-outline-primary marathi-font px-4 py-2" OnClick="btnLoadMore_Click" />
                        </div>
                    </div>

                    <!-- Profile Views Section -->
                    <div class="right-content mt-4">
                        <div class="section-header d-flex justify-content-between align-items-center mb-3">
                            <h3 class="section-title marathi-font">
                                <i class="fas fa-eye text-info"></i> 
                                Profile Viewers
                                <small class="text-muted marathi-font" style="font-size: 1rem;">
                                    (Total <asp:Label ID="lblTotalProfileViews" runat="server" Text="0"></asp:Label> views)
                                </small>
                            </h3>
                            <asp:Button ID="btnRefreshViews" runat="server" Text="🔄 Refresh" 
                                CssClass="btn btn-sm btn-outline-primary marathi-font" OnClick="btnRefreshViews_Click" />
                        </div>

                        <div class="profile-views-container">
                            <asp:Repeater ID="rptProfileViews" runat="server" OnItemDataBound="rptProfileViews_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-view-card" onclick='viewProfile(<%# Eval("ViewedByUserID") %>)'>
                                        <div class="viewer-info">
                                            <div class="viewer-photo">
                                                <!-- Large Viewer Photo -->
                                                <asp:Image ID="imgViewer" runat="server" CssClass="viewer-img-large" 
                                                    ImageUrl='<%# "~/Uploads/" + Eval("ViewedByUserID") + "/profile.jpg" %>'
                                                    onerror="this.src='Images/default-profile.jpg'" />
                                            </div>
                                            <div class="viewer-details">
                                                <div class="viewer-name marathi-font">
                                                    <%# Eval("FullName") %>
                                                </div>
                                                <div class="viewer-stats marathi-font">
                                                    <span class="view-date">
                                                        <i class="fas fa-clock text-muted"></i>
                                                        <!-- FormatViewDate inline implementation -->
                                                        <asp:Literal ID="ltViewDate" runat="server" Text='<%# FormatViewDateInline(Eval("ViewDate")) %>'></asp:Literal>
                                                    </span>
                                                    <span class="view-count">
                                                        <i class="fas fa-eye text-muted"></i>
                                                        <%# Eval("ViewCount") %> times
                                                    </span>
                                                </div>
                                                <div class="viewer-location marathi-font">
                                                    <i class="fas fa-map-marker-alt text-muted"></i>
                                                    <%# Eval("City") %>, <%# Eval("State") %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="view-actions">
                                            <button class="btn btn-sm btn-outline-primary marathi-font" 
                                                onclick='sendInterestFromView(event, <%# Eval("ViewedByUserID") %>)'>
                                                💝 Interest
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning marathi-font" 
                                                onclick='shortlistProfileFromView(event, <%# Eval("ViewedByUserID") %>)'>
                                                ⭐ Shortlist
                                            </button>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoViews" runat="server" Visible="false" CssClass="empty-state">
                                <i class="fas fa-eye-slash fa-3x text-muted mb-3"></i>
                                <h4 class="marathi-font text-muted">No one has viewed your profile yet</h4>
                                <p class="marathi-font text-muted">Tips to make your profile more attractive</p>
                                <asp:Button ID="btnImproveProfile" runat="server" Text="📈 Improve Profile" 
                                    CssClass="btn btn-primary marathi-font mt-2 px-4 py-2" OnClick="btnImproveProfile_Click" />
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Notification Bell -->
    <div class="notification-bell" onclick="toggleNotificationPanel()" id="notificationBell">
        <i class="fas fa-bell"></i>
    </div>

    <!-- Notification Panel -->
    <div class="notification-panel" id="notificationPanel">
        <div class="notification-header">
            <h5 class="marathi-font mb-0">🔔 Notifications</h5>
            <button class="notification-close" onclick="toggleNotificationPanel()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="notification-content">
            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div class="notification-item <%# Convert.ToBoolean(Eval("IsRead")) ? "" : "unread" %>" 
                         onclick='handleNotificationClick(<%# Eval("NotificationID") %>, "<%# Eval("NotificationType") %>")'>
                        <div class="notification-icon <%# Eval("NotificationType") %>">
                            <%# GetNotificationIcon(Eval("NotificationType")) %>
                        </div>
                        <div class="notification-details">
                            <div class="notification-text marathi-font">
                                <%# Eval("Message") %>
                            </div>
                            <div class="notification-time">
                                <%# FormatNotificationTime(Eval("CreatedDate")) %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoNotifications" runat="server" Visible="false" CssClass="text-center p-4">
                <i class="fas fa-bell-slash fa-2x text-muted mb-2"></i>
                <p class="marathi-font text-muted mb-0">No notifications</p>
            </asp:Panel>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />
    <asp:HiddenField ID="hdnCurrentMembership" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // View Profile - Redirect to ViewUserProfile page
        function viewProfile(userID) {
            console.log('Viewing profile:', userID);
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Get remaining counts
        function getRemainingCounts() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetRemainingCounts",
                data: JSON.stringify({ userID: parseInt(currentUserID) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const counts = response.d.split(',');
                    const remainingMessages = counts[0];
                    const remainingInterests = counts[1];
                    
                    // Update UI with remaining counts
                    updateRemainingCountsUI(remainingMessages, remainingInterests);
                },
                error: function () {
                    console.log('Error getting remaining counts');
                }
            });
        }

        // Update UI with remaining counts
        function updateRemainingCountsUI(messages, interests) {
            // Update free user counts
            document.getElementById('remainingMessagesCount').textContent = messages;
            document.getElementById('remainingInterestsCount').textContent = interests;
            
            // Update premium stats if visible
            const messageElement = document.querySelector('.stat-box.premium .stat-number');
            const interestElement = document.querySelectorAll('.stat-box.premium .stat-number')[1];
            
            if (messageElement) {
                messageElement.textContent = messages === '2147483647' ? '∞' : messages;
            }
            if (interestElement) {
                interestElement.textContent = interests === '2147483647' ? '∞' : interests;
            }
        }

        // Check if user can send interest
        function canSendInterest(callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CanSendInterest",
                data: JSON.stringify({ userID: parseInt(currentUserID) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(true); // Assume can send on error
                }
            });
        }

        // Send Interest
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            canSendInterest(function(canSend) {
                if (canSend) {
                    if (confirm('Are you interested in this profile?')) {
                        const button = event.target.closest('.btn-interest') || event.target;
                        const originalText = button.innerHTML;
                        button.innerHTML = '⏳ Sending...';
                        button.disabled = true;

                        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                        // AJAX call to send interest
                        $.ajax({
                            type: "POST",
                            url: "Dashboard.aspx/SendInterest",
                            data: JSON.stringify({
                                sentByUserID: parseInt(currentUserID),
                                targetUserID: toUserID
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d === "success") {
                                    button.innerHTML = '✅ Interest Sent';
                                    button.style.background = '#28a745';
                                    button.disabled = true;
                                    showNotification('Interest sent successfully!', 'success');
                                    
                                    // Refresh counts and stats
                                    setTimeout(() => {
                                        getRemainingCounts();
                                        location.reload();
                                    }, 2000);
                                } else if (response.d === "exists") {
                                    button.innerHTML = '✅ Already Sent';
                                    button.style.background = '#ffc107';
                                    button.disabled = true;
                                    showNotification('You have already sent interest to this profile!', 'info');
                                } else if (response.d === "limit_exceeded") {
                                    button.innerHTML = originalText;
                                    button.disabled = false;
                                    showNotification('You have exceeded daily interest limit! Upgrade to premium.', 'error');
                                    setTimeout(() => {
                                        window.location.href = 'Membership.aspx';
                                    }, 2000);
                                } else {
                                    button.innerHTML = originalText;
                                    button.disabled = false;
                                    showNotification('Error sending interest!', 'error');
                                }
                            },
                            error: function () {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        });
                    }
                } else {
                    showNotification('You have exceeded daily interest limit! Upgrade to premium.', 'error');
                    setTimeout(() => {
                        window.location.href = 'Membership.aspx';
                    }, 2000);
                }
            });
        }

        // Check if user can send message
        function canSendMessage(callback) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/CanSendMessage",
                data: JSON.stringify({ userID: parseInt(currentUserID) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    callback(response.d);
                },
                error: function () {
                    callback(true); // Assume can send on error
                }
            });
        }

        // Send Message with premium check
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            canSendMessage(function(canSend) {
                if (canSend) {
                    proceedWithMessage(event, toUserID);
                } else {
                    showNotification('You have exceeded daily message limit! Upgrade to premium.', 'error');
                    setTimeout(() => {
                        window.location.href = 'Membership.aspx';
                    }, 2000);
                }
            });
        }

        function proceedWithMessage(event, toUserID) {
            const message = prompt('Enter your message (max 500 characters):', 'I like your profile. Please contact me.');
            if (message && message.length <= 500) {
                const button = event.target.closest('.btn-message') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                showNotification('Sending message...', 'info');

                // AJAX call to send message
                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/SendMessage",
                    data: JSON.stringify({
                        fromUserID: parseInt(currentUserID),
                        toUserID: toUserID,
                        messageText: message
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "success") {
                            button.innerHTML = '✅ Message Sent';
                            button.style.background = '#28a745';
                            button.disabled = true;
                            showNotification('Message sent successfully!', 'success');

                            // Refresh counts and stats
                            setTimeout(() => {
                                getRemainingCounts();
                                location.reload();
                            }, 2000);
                        } else if (response.d === "limit_exceeded") {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('You have exceeded daily message limit! Upgrade to premium.', 'error');
                            setTimeout(() => {
                                window.location.href = 'Membership.aspx';
                            }, 2000);
                        } else {
                            button.innerHTML = originalText;
                            button.disabled = false;
                            showNotification('Error sending message!', 'error');
                        }
                    },
                    error: function () {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error sending message!', 'error');
                    }
                });
            } else if (message) {
                alert('Message cannot exceed 500 characters');
            }
        }

        // Send interest from profile views
        function sendInterestFromView(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            canSendInterest(function(canSend) {
                if (canSend) {
                    if (confirm('Are you interested in this profile?')) {
                        const button = event.target;
                        const originalText = button.innerHTML;
                        button.innerHTML = '⏳ Sending...';
                        button.disabled = true;

                        const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                        // AJAX call to send interest
                        $.ajax({
                            type: "POST",
                            url: "Dashboard.aspx/SendInterest",
                            data: JSON.stringify({
                                sentByUserID: parseInt(currentUserID),
                                targetUserID: toUserID
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d === "success") {
                                    button.innerHTML = '✅ Interest Sent';
                                    button.style.background = '#28a745';
                                    button.disabled = true;
                                    showNotification('Interest sent successfully!', 'success');

                                    // Refresh counts
                                    setTimeout(getRemainingCounts, 1000);
                                } else if (response.d === "exists") {
                                    button.innerHTML = '✅ Already Sent';
                                    button.style.background = '#ffc107';
                                    button.disabled = true;
                                    showNotification('You have already sent interest to this profile!', 'info');
                                } else if (response.d === "limit_exceeded") {
                                    button.innerHTML = originalText;
                                    button.disabled = false;
                                    showNotification('You have exceeded daily interest limit! Upgrade to premium.', 'error');
                                    setTimeout(() => {
                                        window.location.href = 'Membership.aspx';
                                    }, 2000);
                                } else {
                                    button.innerHTML = originalText;
                                    button.disabled = false;
                                    showNotification('Error sending interest!', 'error');
                                }
                            },
                            error: function () {
                                button.innerHTML = originalText;
                                button.disabled = false;
                                showNotification('Error sending interest!', 'error');
                            }
                        });
                    }
                } else {
                    showNotification('You have exceeded daily interest limit! Upgrade to premium.', 'error');
                    setTimeout(() => {
                        window.location.href = 'Membership.aspx';
                    }, 2000);
                }
            });
        }

        // Shortlist Profile Function
        function shortlistProfile(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target.closest('.btn-shortlist') || event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                        
                        // Update shortlist count
                        updateShortlistCount();
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Shortlist from profile views
        function shortlistProfileFromView(event, userID) {
            event.stopPropagation();
            event.preventDefault();

            const button = event.target;
            const originalText = button.innerHTML;
            button.innerHTML = '⏳ Shortlisting...';
            button.disabled = true;

            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/ShortlistProfile",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    shortlistedUserID: userID
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        button.innerHTML = '✅ Shortlisted';
                        button.style.background = '#28a745';
                        button.disabled = true;
                        showNotification('Profile shortlisted successfully!', 'success');
                        
                        // Update shortlist count
                        updateShortlistCount();
                    } else if (response.d === "exists") {
                        button.innerHTML = '✅ Already Shortlisted';
                        button.style.background = '#ffc107';
                        button.disabled = true;
                        showNotification('You have already shortlisted this profile!', 'info');
                    } else {
                        button.innerHTML = originalText;
                        button.disabled = false;
                        showNotification('Error shortlisting!', 'error');
                    }
                },
                error: function () {
                    button.innerHTML = originalText;
                    button.disabled = false;
                    showNotification('Error shortlisting!', 'error');
                }
            });
        }

        // Update shortlist count in badges
        function updateShortlistCount() {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetShortlistCount",
                data: JSON.stringify({ userID: parseInt(currentUserID) }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const count = response.d;
                    const shortlistBadge = document.querySelector('#<%= pnlShortlistedBadge.ClientID %>');
                    const shortlistCount = document.querySelector('#<%= lblShortlistedCount.ClientID %>');
                    
                    if (shortlistBadge && shortlistCount) {
                        if (count > 0) {
                            shortlistBadge.style.display = 'flex';
                            shortlistCount.textContent = count > 99 ? '99+' : count;
                        } else {
                            shortlistBadge.style.display = 'none';
                        }
                    }
                }
            });
        }

        // Check if profile is already shortlisted on page load
        function checkShortlistStatus() {
            const profileCards = document.querySelectorAll('.profile-card');
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
            
            profileCards.forEach(card => {
                const buttons = card.querySelectorAll('.btn-shortlist');
                buttons.forEach(btn => {
                    const userID = btn.getAttribute('onclick').match(/\d+/)[0];
                    
                    $.ajax({
                        type: "POST",
                        url: "Dashboard.aspx/CheckShortlistStatus",
                        data: JSON.stringify({
                            userID: parseInt(currentUserID),
                            shortlistedUserID: parseInt(userID)
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d) {
                                btn.innerHTML = '✅ Already Shortlisted';
                                btn.style.background = '#ffc107';
                                btn.disabled = true;
                            }
                        }
                    });
                });
            });
        }

        // View profile from views list
        function viewProfileFromList(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Notification function
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '18px 24px';
            notification.style.borderRadius = '15px';
            notification.style.color = 'white';
            notification.style.fontWeight = 'bold';
            notification.style.zIndex = '10000';
            notification.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
            notification.style.transition = 'all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
            notification.style.backdropFilter = 'blur(10px)';
            notification.style.border = '1px solid rgba(255,255,255,0.2)';
            notification.style.maxWidth = '400px';
            notification.style.transform = 'translateX(100px)';
            notification.style.opacity = '0';

            if (type === 'success') {
                notification.style.background = 'linear-gradient(135deg, rgba(40, 167, 69, 0.9) 0%, rgba(25, 135, 84, 0.9) 100%)';
            } else if (type === 'error') {
                notification.style.background = 'linear-gradient(135deg, rgba(220, 53, 69, 0.9) 0%, rgba(189, 33, 48, 0.9) 100%)';
            } else if (type === 'info') {
                notification.style.background = 'linear-gradient(135deg, rgba(23, 162, 184, 0.9) 0%, rgba(12, 99, 112, 0.9) 100%)';
            }

            notification.innerHTML = message;
            document.body.appendChild(notification);

            // Animate in
            setTimeout(() => {
                notification.style.transform = 'translateX(0)';
                notification.style.opacity = '1';
            }, 100);

            // Remove notification after 4 seconds
            setTimeout(() => {
                notification.style.transform = 'translateX(100px)';
                notification.style.opacity = '0';
                setTimeout(() => {
                    if (document.body.contains(notification)) {
                        document.body.removeChild(notification);
                    }
                }, 400);
            }, 4000);
        }

        // Real-time notification updates
        function startNotificationPolling() {
            setInterval(function() {
                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
                
                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/CheckNewNotifications",
                    data: JSON.stringify({ userID: parseInt(currentUserID) }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        const counts = response.d.split(',');
                        const newMessages = parseInt(counts[0]);
                        const newInterests = parseInt(counts[1]);
                        
                        updateNotificationBadges(newMessages, newInterests);
                    },
                    error: function() {
                        console.log('Error checking notifications');
                    }
                });
            }, 30000); // Check every 30 seconds
        }

        function updateNotificationBadges(newMessages, newInterests) {
            // Update messages badge
            const messagesBadge = document.getElementById('<%= pnlMessagesBadge.ClientID %>');
            const messagesCount = document.getElementById('<%= lblMessagesCount.ClientID %>');
            
            if (messagesBadge && messagesCount) {
                if (newMessages > 0) {
                    messagesBadge.style.display = 'flex';
                    messagesCount.textContent = newMessages > 99 ? '99+' : newMessages;
                    messagesBadge.className = 'nav-badge pulse';
                } else {
                    messagesBadge.style.display = 'none';
                }
            }
            
            // Update interests badge
            const interestsBadge = document.getElementById('<%= pnlInterestsBadge.ClientID %>');
            const interestsCount = document.getElementById('<%= lblInterestsCount.ClientID %>');
            
            if (interestsBadge && interestsCount) {
                if (newInterests > 0) {
                    interestsBadge.style.display = 'flex';
                    interestsCount.textContent = newInterests > 99 ? '99+' : newInterests;
                    interestsBadge.className = 'nav-badge pulse';
                } else {
                    interestsBadge.style.display = 'none';
                }
            }
            
            // Update notification bell
            const notificationBell = document.getElementById('notificationBell');
            if (newMessages > 0 || newInterests > 0) {
                notificationBell.classList.add('has-notifications');
            } else {
                notificationBell.classList.remove('has-notifications');
            }
        }

        // Toggle notification panel
        function toggleNotificationPanel() {
            const panel = document.getElementById('notificationPanel');
            panel.classList.toggle('show');
            
            // Mark as read when opening
            if (panel.classList.contains('show')) {
                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;
                
                $.ajax({
                    type: "POST",
                    url: "Dashboard.aspx/MarkNotificationsAsRead",
                    data: JSON.stringify({ 
                        userID: parseInt(currentUserID),
                        notificationType: "all"
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d === "success") {
                            console.log('Notifications marked as read');
                        }
                    }
                });
            }
        }

        // Handle notification click
        function handleNotificationClick(notificationID, notificationType) {
            const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

            // Mark as read
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/MarkNotificationsAsRead",
                data: JSON.stringify({
                    userID: parseInt(currentUserID),
                    notificationType: notificationType
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            });

            // Redirect based on notification type
            switch (notificationType) {
                case 'message':
                    window.location.href = 'Messages.aspx';
                    break;
                case 'interest':
                    window.location.href = 'Interests.aspx';
                    break;
                case 'shortlist':
                    window.location.href = 'Shortlisted.aspx';
                    break;
                default:
                    window.location.href = 'Dashboard.aspx';
            }
        }

        // Initialize page enhancements
        document.addEventListener('DOMContentLoaded', function () {
            // Add hover effects to profile cards
            const profileCards = document.querySelectorAll('.profile-card');
            profileCards.forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-12px) scale(1.02)';
                });

                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Add loading animation to buttons
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(btn => {
                btn.addEventListener('click', function () {
                    if (!this.disabled) {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                        this.disabled = true;

                        // Revert after 2 seconds for demo
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.disabled = false;
                        }, 2000);
                    }
                });
            });

            // Image error handling
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.addEventListener('error', function () {
                    this.src = 'Images/default-profile.jpg';
                });
            });

            // Get remaining counts on page load
            setTimeout(getRemainingCounts, 1000);

            // Start real-time notification polling
            startNotificationPolling();

            // Initialize shortlist status check
            setTimeout(checkShortlistStatus, 1000);
            setTimeout(updateShortlistCount, 1500);

            // Add parallax effect to dashboard background
            window.addEventListener('scroll', function () {
                const scrolled = window.pageYOffset;
                const parallax = document.querySelector('.dashboard-container::before');
                if (parallax) {
                    parallax.style.transform = `translateY(${scrolled * 0.5}px)`;
                }
            });
        });



        // View Profile - Redirect to ViewUserProfile page
        function viewProfile(userID) {
            console.log('Viewing profile:', userID);
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Profile views मधून view profile
        function viewProfileFromList(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }
        // Add smooth scrolling for better UX
        function smoothScrollTo(element) {
            element.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    </script>
</asp:Content>









--%>
