

<%@ Page Title="Marathi Matrimony - Matches" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Matches.aspx.cs" Inherits="JivanBandhan4.Matches" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /* Premium Modern CSS */
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }

        .marathi-font {
            font-family: 'Nirmala UI', 'Noto Sans Devanagari', 'Arial Unicode MS', sans-serif !important;
        }

        .marathi-font .navbar-brand,
        .marathi-font .nav-link,
        .marathi-font .dropdown-item,
        .marathi-font .footer,
        .marathi-font h1,
        .marathi-font h2,
        .marathi-font h3,
        .marathi-font h4,
        .marathi-font h5,
        .marathi-font h6 {
            font-family: 'Nirmala UI', 'Noto Sans Devanagari', 'Arial Unicode MS', sans-serif !important;
        }
        
        .matches-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .matches-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 400px;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
            clip-path: polygon(0 0, 100% 0, 100% 60%, 0 100%);
            z-index: 0;
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 35px 70px rgba(0, 0, 0, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(255,255,255,0.95) 100%);
            backdrop-filter: blur(20px);
            color: #2c3e50;
            border-radius: 0 0 40px 40px;
            padding: 50px 0 40px;
            margin-bottom: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.3);
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
            border-radius: 42px;
            z-index: -1;
            opacity: 0.1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 30px;
            margin: 0 auto;
            max-width: 1400px;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.3);
            position: sticky;
            top: 30px;
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 30px;
            margin-bottom: 30px;
        }
        
        .user-photo-large {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 8px solid rgba(255,255,255,0.9);
            margin: 0 auto 25px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
        }
        
        .user-photo-large:hover {
            transform: scale(1.08);
            border-color: #d63384;
            box-shadow: 0 25px 60px rgba(214, 51, 132, 0.3);
        }
        
        .user-name {
            font-size: 1.5rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 12px;
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 25px 0;
        }
        
        .stat-box {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            padding: 20px;
            border-radius: 18px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            display: block;
            font-size: 1.8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .nav-menu {
            margin: 30px 0;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 18px 20px;
            margin: 8px 0;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #495057;
            text-decoration: none;
            background: rgba(248,249,250,0.7);
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
            margin-right: 15px;
            width: 20px;
            text-align: center;
            font-size: 1.2rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 20px;
            margin-bottom: 35px;
            font-size: 2.2rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 120px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        /* View Toggle Buttons */
        .view-toggle-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .view-toggle-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            background: rgba(248,249,250,0.8);
            color: #495057;
            border: 2px solid transparent;
        }
        
        .view-toggle-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        /* Single Profile View */
        .single-profile-view {
            display: block;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        .profile-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(248,249,250,0.95) 100%);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
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
            border-radius: 26px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .profile-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 30px 70px rgba(0,0,0,0.2);
        }
        
        .profile-card:hover::before {
            opacity: 0.3;
        }
        
        .profile-header-large {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .profile-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.7;
            transition: transform 0.4s ease;
        }
        
        .profile-card:hover .profile-bg {
            transform: scale(1.1);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -70px;
            left: 50%;
            transform: translateX(-50%);
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 6px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.1);
            border-color: #d63384;
        }
        
        .profile-main-photo-large {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        /* Comparison View */
        .comparison-view {
            display: none;
        }
        
        .profiles-comparison-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin: 20px 0;
        }
        
        .comparison-profile-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(248,249,250,0.95) 100%);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.3);
            position: relative;
        }
        
        .comparison-profile-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 60px rgba(0,0,0,0.15);
        }
        
        .comparison-profile-header {
            position: relative;
            height: 250px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .comparison-profile-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.6;
            transition: transform 0.4s ease;
        }
        
        .comparison-profile-card:hover .comparison-profile-bg {
            transform: scale(1.1);
        }
        
        .comparison-photo-container {
            position: absolute;
            bottom: -90px;
            left: 50%;
            transform: translateX(-50%);
            width: 220px;
            height: 220px;
            border-radius: 50%;
            border: 8px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.4);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
        }
        
        .comparison-photo-container:hover {
            transform: translateX(-50%) scale(1.1);
            border-color: #d63384;
        }
        
        .comparison-profile-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        .comparison-profile-content {
            padding: 110px 25px 25px;
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
        }
        
        .match-score-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #ff6b6b, #d63384);
            color: white;
            padding: 12px 16px;
            border-radius: 25px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.4);
            z-index: 10;
            border: 3px solid rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
        }
        
        .match-percentage {
            display: block;
            font-size: 1.3rem;
            line-height: 1;
        }
        
        .match-label {
            font-size: 0.8rem;
            opacity: 0.9;
        }
        
        .online-indicator {
            position: absolute;
            top: 20px;
            left: 20px;
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
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 20px;
            left: 50px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 90px 25px 25px;
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
        }
        
        .profile-name {
            font-size: 1.4rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .profile-age {
            color: #d63384;
            font-weight: 600;
            margin-bottom: 8px;
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
        
        .match-criteria {
            background: rgba(248,249,250,0.8);
            border-radius: 18px;
            padding: 20px;
            margin: 20px 0;
            border: 1px solid rgba(233,236,239,0.8);
            backdrop-filter: blur(10px);
        }
        
        .criteria-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 0.9rem;
        }
        
        .criteria-item:last-child {
            margin-bottom: 0;
        }
        
        .criteria-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .criteria-value {
            font-weight: bold;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            min-width: 50px;
            text-align: center;
        }
        
        .criteria-value.high { 
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724; 
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }
        
        .criteria-value.medium { 
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404; 
            box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3);
        }
        
        .criteria-value.low { 
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24; 
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }
        
        .profile-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 14px 20px;
            border: none;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            max-width: 120px;
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
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            border-radius: 24px;
            border: 2px dashed rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(10px);
        }
        
        .empty-state i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
        }
        
        .filter-section {
            background: linear-gradient(135deg, rgba(248,249,250,0.95) 0%, rgba(233,236,239,0.8) 100%);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
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
            padding: 14px 16px;
            border: 2px solid rgba(233, 236, 239, 0.8);
            border-radius: 14px;
            background: rgba(255,255,255,0.9);
            transition: all 0.3s ease;
            font-size: 0.95rem;
            backdrop-filter: blur(5px);
        }
        
        .filter-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.15);
            background: rgba(255,255,255,0.95);
        }
        
        .section-header {
            background: linear-gradient(135deg, rgba(248,249,250,0.95) 0%, rgba(233,236,239,0.8) 100%);
            padding: 25px 30px;
            border-radius: 20px;
            border: 1px solid rgba(233, 236, 239, 0.8);
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }
        
        .logout-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            border-radius: 16px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
            position: relative;
            overflow: hidden;
            margin-top: 20px;
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
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
        
        /* Responsive Design */
        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 320px 1fr;
                gap: 25px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 25px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .left-sidebar {
                position: relative;
                top: 0;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            }
            
            .profiles-comparison-container {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }
        
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .right-content {
                padding: 25px;
            }
            
            .welcome-banner {
                padding: 40px 0 30px;
            }
            
            .view-toggle-buttons {
                flex-direction: column;
                gap: 10px;
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
            
            .main-layout {
                padding: 0 15px;
            }
            
            .right-content {
                padding: 20px;
            }
            
            .comparison-photo-container {
                width: 180px;
                height: 180px;
                bottom: -80px;
            }
            
            .comparison-profile-content {
                padding: 100px 20px 20px;
            }
        }
    </style>

    <div class="container mt-4">
        <h1><asp:Literal ID="litPageTitle" runat="server" Text="Welcome to JivanBandhan"></asp:Literal></h1>
        <p><asp:Literal ID="litPageDescription" runat="server" Text="Find your perfect life partner..."></asp:Literal></p>
    </div>

    <div class="matches-container">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="font-size: 2.5rem; margin-bottom: 10px;">💖 Your Perfect Matches</h1>
                        <p class="marathi-font mb-0" style="font-size: 1.2rem; opacity: 0.8;">Discover profiles that match your preferences and share mutual compatibility</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge glass-card marathi-font p-3" style="background: rgba(255,255,255,0.9);">
                                💝 <asp:Label ID="lblTotalMatches" runat="server" Text="0" style="font-size: 1.1rem;"></asp:Label> Matches
                            </span>
                            <span class="badge glass-card marathi-font p-3" style="background: rgba(255,255,255,0.9);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free" style="font-size: 1.1rem;"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Layout -->
        <div class="container">
            <div class="main-layout">
                <!-- Left Sidebar - Current User Profile -->
                <div class="left-sidebar glass-card">
                    <div class="user-profile-card">
                        <!-- Large Profile Photo -->
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font" style="background: rgba(248,249,250,0.7); padding: 15px; border-radius: 15px; margin: 10px 0;">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Match Statistics -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMutualMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Mutual</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Today</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblNewMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">New</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblPremiumMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Premium</span>
                            </div>
                        </div>

                        <!-- Match Criteria Info -->
                        <div class="match-criteria">
                            <h6 class="marathi-font text-primary mb-3" style="text-align: center;">🎯 Your Preferences</h6>
                            <div class="feature-list small">
                                <div class="criteria-item">
                                    <span class="criteria-label">Gender:</span>
                                    <span class="criteria-value high"><asp:Label ID="lblPreferredGender" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Age Range:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredAge" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Education:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredEducation" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Occupation:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredOccupation" runat="server" Text=""></asp:Label></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item active" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                            <asp:Panel ID="pnlMatchesBadge" runat="server" CssClass="nav-badge pulse" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblMatchesCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
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
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content - Matched Profiles -->
                <div class="right-content glass-card">
                    <!-- Match Filters -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: #8B0000; font-size: 1.3rem;">
                            <i class="fas fa-filter"></i> Refine Your Matches
                        </h5>
                        <div class="filter-row">
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-heart"></i> Match Type</div>
                                <asp:DropDownList ID="ddlMatchType" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlMatchType_SelectedIndexChanged">
                                    <asp:ListItem Value="all">All Matches</asp:ListItem>
                                    <asp:ListItem Value="mutual">Mutual Matches</asp:ListItem>
                                    <asp:ListItem Value="new">New Today</asp:ListItem>
                                    <asp:ListItem Value="premium">Premium Profiles</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-sort"></i> Sort By</div>
                                <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                                    <asp:ListItem Value="newest">Newest First</asp:ListItem>
                                    <asp:ListItem Value="relevance">Best Match</asp:ListItem>
                                    <asp:ListItem Value="premium">Premium First</asp:ListItem>
                                    <asp:ListItem Value="age">Age</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-chart-line"></i> Match Score</div>
                                <asp:DropDownList ID="ddlMatchScore" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlMatchScore_SelectedIndexChanged">
                                    <asp:ListItem Value="0">All Scores</asp:ListItem>
                                    <asp:ListItem Value="80">80%+ Match</asp:ListItem>
                                    <asp:ListItem Value="60">60%+ Match</asp:ListItem>
                                    <asp:ListItem Value="40">40%+ Match</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnFindMore" runat="server" Text="🔍 Find More Matches" 
                                CssClass="btn marathi-font px-4 py-2" 
                                style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 20px; box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);"
                                OnClick="btnFindMore_Click" />
                        </div>
                    </div>

                    <!-- View Toggle Buttons -->
                    <div class="view-toggle-buttons">
                        <button class="view-toggle-btn active marathi-font" onclick="toggleView('single')">
                            <i class="fas fa-user"></i> Single View
                        </button>
                        <button class="view-toggle-btn marathi-font" onclick="toggleView('comparison')">
                            <i class="fas fa-columns"></i> Compare Two Profiles
                        </button>
                    </div>

                    <!-- Matched Profiles Section -->
                    <div class="matches-section">
                        <div class="section-header d-flex justify-content-between align-items-center">
                            <h3 class="section-title marathi-font">
                                <i class="fas fa-heart text-danger"></i> 
                                Perfect Matches For You
                                <small class="text-muted marathi-font" style="font-size: 1rem; display: block; margin-top: 8px;">
                                    (<asp:Label ID="lblMatchInfo" runat="server" Text=""></asp:Label>)
                                </small>
                            </h3>
                            <asp:Button ID="btnRefreshMatches" runat="server" Text="🔄 Refresh" 
                                CssClass="btn btn-sm marathi-font" 
                                style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 15px;"
                                OnClick="btnRefreshMatches_Click" />
                        </div>
                        
                        <!-- Single Profile View -->
                        <div id="singleProfileView" class="single-profile-view">
                            <div class="profile-grid">
                                <asp:Repeater ID="rptMatchedProfiles" runat="server" OnItemDataBound="rptMatchedProfiles_ItemDataBound">
                                    <ItemTemplate>
                                        <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                            <div class="profile-header-large">
                                                <!-- Background with user's photo -->
                                                <img src='<%# GetProfilePhotoUrl(Eval("UserID")) %>' 
                                                     class="profile-bg" alt="background" 
                                                     onerror="this.src='Images/default-profile.jpg'" />
                                                
                                                <!-- Match Score Badge -->
                                                <div class="match-score-badge">
                                                    <span class="match-percentage"><%# Eval("MatchPercentage") %>%</span>
                                                    <span class="match-label">MATCH</span>
                                                </div>
                                                
                                                <!-- Large Profile Photo -->
                                                <div class="profile-photo-container-large">
                                                    <asp:Image ID="imgProfile" runat="server" CssClass="profile-main-photo-large" 
                                                        ImageUrl='<%# GetProfilePhotoUrl(Eval("UserID")) %>' 
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
                                                    <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                                </div>
                                                <div class="profile-location marathi-font">
                                                    <i class="fas fa-map-marker-alt text-muted"></i> 
                                                    <%# Eval("City") %>, <%# Eval("State") %>
                                                </div>
                                                
                                                <!-- Match Criteria -->
                                                <div class="match-criteria">
                                                    <div class="criteria-item">
                                                        <span class="criteria-label">Age Match:</span>
                                                        <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("AgeMatchScore"))) %>">
                                                            <%# Eval("AgeMatchScore") %>%
                                                        </span>
                                                    </div>
                                                    <div class="criteria-item">
                                                        <span class="criteria-label">Education:</span>
                                                        <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("EducationMatchScore"))) %>">
                                                            <%# Eval("EducationMatchScore") %>%
                                                        </span>
                                                    </div>
                                                    <div class="criteria-item">
                                                        <span class="criteria-label">Location:</span>
                                                        <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("LocationMatchScore"))) %>">
                                                            <%# Eval("LocationMatchScore") %>%
                                                        </span>
                                                    </div>
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
                        </div>
                        
                        <!-- Comparison View -->
                        <div id="comparisonView" class="comparison-view">
                            <div class="profiles-comparison-container">
                                <asp:Repeater ID="rptComparisonProfiles" runat="server" OnItemDataBound="rptComparisonProfiles_ItemDataBound">
                                    <ItemTemplate>
                                        <div class="comparison-profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                            <div class="comparison-profile-header">
                                                <!-- Background with user's photo -->
                                                <img src='<%# GetProfilePhotoUrl(Eval("UserID")) %>' 
                                                     class="comparison-profile-bg" alt="background" 
                                                     onerror="this.src='Images/default-profile.jpg'" />
                                                
                                                <!-- Match Score Badge -->
                                                <div class="match-score-badge">
                                                    <span class="match-percentage"><%# Eval("MatchPercentage") %>%</span>
                                                    <span class="match-label">MATCH</span>
                                                </div>
                                                
                                                <!-- Large Profile Photo -->
                                                <div class="comparison-photo-container">
                                                    <asp:Image ID="imgComparisonProfile" runat="server" CssClass="comparison-profile-photo" 
                                                        ImageUrl='<%# GetProfilePhotoUrl(Eval("UserID")) %>' 
                                                        onerror="this.src='Images/default-profile.jpg'" />
                                                </div>
                                                
                                                <div class="online-indicator <%# (new Random().Next(0,100) > 50 ? "online" : "offline") %>"></div>
                                                <div class="premium-badge" style='display: <%# Convert.ToBoolean(Eval("IsPremium")) ? "block" : "none" %>'>
                                                    ⭐ Premium
                                                </div>
                                            </div>
                                            <div class="comparison-profile-content">
                                                <div class="profile-name marathi-font">
                                                    <%# Eval("FullName") %>
                                                </div>
                                                <div class="profile-age marathi-font">
                                                    <asp:Literal ID="ltComparisonAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                                </div>
                                                <div class="profile-location marathi-font">
                                                    <i class="fas fa-map-marker-alt text-muted"></i> 
                                                    <%# Eval("City") %>, <%# Eval("State") %>
                                                </div>
                                                
                                                <!-- Simplified Match Criteria for Comparison -->
                                                <div class="match-criteria">
                                                    <div class="criteria-item">
                                                        <span class="criteria-label">Overall Match:</span>
                                                        <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("MatchPercentage"))) %>">
                                                            <%# Eval("MatchPercentage") %>%
                                                        </span>
                                                    </div>
                                                    <div class="criteria-item">
                                                        <span class="criteria-label">Age Match:</span>
                                                        <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("AgeMatchScore"))) %>">
                                                            <%# Eval("AgeMatchScore") %>%
                                                        </span>
                                                    </div>
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
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        
                        <asp:Panel ID="pnlNoMatches" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-heart-broken fa-4x text-muted mb-3"></i>
                            <h4 class="marathi-font text-muted">No perfect matches found yet</h4>
                            <p class="marathi-font text-muted">We're working hard to find your perfect match. Please check back later or update your preferences.</p>
                            <div class="mt-4">
                                <asp:Button ID="btnUpdatePreferences" runat="server" Text="⚙️ Update Preferences" 
                                    CssClass="btn marathi-font px-4 py-2 me-3" 
                                    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 20px;"
                                    OnClick="btnUpdatePreferences_Click" />
                                <asp:Button ID="btnBrowseProfiles" runat="server" Text="👀 Browse All Profiles" 
                                    CssClass="btn marathi-font px-4 py-2" 
                                    style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 20px; color: #495057;"
                                    OnClick="btnBrowseProfiles_Click" />
                            </div>
                        </asp:Panel>

                        <!-- Load More Button -->
                        <div class="text-center mt-4" id="pnlLoadMore" runat="server" visible="false">
                            <asp:Button ID="btnLoadMore" runat="server" Text="📥 Load More Matches" 
                                CssClass="btn marathi-font px-4 py-2" 
                                style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 20px; color: #495057;"
                                OnClick="btnLoadMore_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hdnCurrentUserID" runat="server" />
    <asp:HiddenField ID="hdnCurrentUserGender" runat="server" />
    <asp:HiddenField ID="hdnCurrentMembership" runat="server" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <script>
        // Toggle between single and comparison view
        function toggleView(viewType) {
            const singleView = document.getElementById('singleProfileView');
            const comparisonView = document.getElementById('comparisonView');
            const buttons = document.querySelectorAll('.view-toggle-btn');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            
            if (viewType === 'comparison') {
                singleView.style.display = 'none';
                comparisonView.style.display = 'block';
                event.target.classList.add('active');
            } else {
                singleView.style.display = 'block';
                comparisonView.style.display = 'none';
                event.target.classList.add('active');
            }
        }

        // View Profile - Redirect to ViewUserProfile page
        function viewProfile(userID) {
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest Function
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you interested in this profile?')) {
                const button = event.target.closest('.btn-interest') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                // AJAX call to send interest
                $.ajax({
                    type: "POST",
                    url: "Matches.aspx/SendInterest",
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
        }

        // Send Message Function
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

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
                    url: "Matches.aspx/SendMessage",
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
                url: "Matches.aspx/ShortlistProfile",
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

        // Add hover effects and animations
        document.addEventListener('DOMContentLoaded', function () {
            // Add hover effects to profile cards
            const profileCards = document.querySelectorAll('.profile-card, .comparison-profile-card');
            profileCards.forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-12px) scale(1.02)';
                });

                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Add parallax effect to background
            window.addEventListener('scroll', function () {
                const scrolled = window.pageYOffset;
                const parallax = document.querySelector('.matches-container::before');
                if (parallax) {
                    parallax.style.transform = `translateY(${scrolled * 0.5}px)`;
                }
            });
        });
    </script>
</asp:Content>




















<%--<%@ Page Title="Marathi Matrimony - Matches" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeBehind="Matches.aspx.cs" Inherits="JivanBandhan4.Matches" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        /* Premium Modern CSS */
        .marathi-font {
            font-family: 'Nirmala UI', 'Arial Unicode MS', sans-serif;
        }




        .marathi-font {
    font-family: 'Nirmala UI', 'Noto Sans Devanagari', 'Arial Unicode MS', sans-serif !important;
}

.marathi-font .navbar-brand,
.marathi-font .nav-link,
.marathi-font .dropdown-item,
.marathi-font .footer,
.marathi-font h1,
.marathi-font h2,
.marathi-font h3,
.marathi-font h4,
.marathi-font h5,
.marathi-font h6 {
    font-family: 'Nirmala UI', 'Noto Sans Devanagari', 'Arial Unicode MS', sans-serif !important;
}



        
        .matches-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 0;
            position: relative;
            overflow-x: hidden;
        }
        
        .matches-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 400px;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
            clip-path: polygon(0 0, 100% 0, 100% 60%, 0 100%);
            z-index: 0;
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 35px 70px rgba(0, 0, 0, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(255,255,255,0.95) 100%);
            backdrop-filter: blur(20px);
            color: #2c3e50;
            border-radius: 0 0 40px 40px;
            padding: 50px 0 40px;
            margin-bottom: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            position: relative;
            border: 1px solid rgba(255,255,255,0.3);
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
            border-radius: 42px;
            z-index: -1;
            opacity: 0.1;
        }
        
        .main-layout {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 30px;
            margin: 0 auto;
            max-width: 1400px;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }
        
        .left-sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            height: fit-content;
            border: 1px solid rgba(255,255,255,0.3);
            position: sticky;
            top: 30px;
        }
        
        .user-profile-card {
            text-align: center;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 30px;
            margin-bottom: 30px;
        }
        
        .user-photo-large {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            object-fit: cover;
            border: 8px solid rgba(255,255,255,0.9);
            margin: 0 auto 25px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 4px;
        }
        
        .user-photo-large:hover {
            transform: scale(1.08);
            border-color: #d63384;
            box-shadow: 0 25px 60px rgba(214, 51, 132, 0.3);
        }
        
        .user-name {
            font-size: 1.5rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 12px;
        }
        
        .quick-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 25px 0;
        }
        
        .stat-box {
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            padding: 20px;
            border-radius: 18px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        
        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            display: block;
            font-size: 1.8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .nav-menu {
            margin: 30px 0;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 18px 20px;
            margin: 8px 0;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #495057;
            text-decoration: none;
            background: rgba(248,249,250,0.7);
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
            margin-right: 15px;
            width: 20px;
            text-align: center;
            font-size: 1.2rem;
        }
        
        .right-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .section-title {
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            border-bottom: 3px solid;
            border-image: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%) 1;
            padding-bottom: 20px;
            margin-bottom: 35px;
            font-size: 2.2rem;
            font-weight: bold;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 120px;
            height: 3px;
            background: linear-gradient(135deg, #d63384 0%, #ff6b6b 100%);
            border-radius: 3px;
        }
        
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        
        .profile-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(248,249,250,0.95) 100%);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
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
            border-radius: 26px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .profile-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 30px 70px rgba(0,0,0,0.2);
        }
        
        .profile-card:hover::before {
            opacity: 0.3;
        }
        
        .profile-header-large {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .profile-bg {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.7;
            transition: transform 0.4s ease;
        }
        
        .profile-card:hover .profile-bg {
            transform: scale(1.1);
        }
        
        .profile-photo-container-large {
            position: absolute;
            bottom: -70px;
            left: 50%;
            transform: translateX(-50%);
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 6px solid rgba(255,255,255,0.9);
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3px;
        }
        
        .profile-photo-container-large:hover {
            transform: translateX(-50%) scale(1.1);
            border-color: #d63384;
        }
        
        .profile-main-photo-large {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.4s ease;
            border-radius: 50%;
        }
        
        .match-score-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #ff6b6b, #d63384);
            color: white;
            padding: 12px 16px;
            border-radius: 25px;
            font-weight: bold;
            text-align: center;
            box-shadow: 0 8px 25px rgba(214, 51, 132, 0.4);
            z-index: 10;
            border: 3px solid rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
        }
        
        .match-percentage {
            display: block;
            font-size: 1.3rem;
            line-height: 1;
        }
        
        .match-label {
            font-size: 0.8rem;
            opacity: 0.9;
        }
        
        .online-indicator {
            position: absolute;
            top: 20px;
            left: 20px;
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
        
        .offline {
            background: #6c757d;
        }
        
        .premium-badge {
            position: absolute;
            top: 20px;
            left: 50px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 10;
            animation: pulse 2s infinite;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }
        
        .profile-content-large {
            padding: 90px 25px 25px;
            text-align: center;
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(248,249,250,0.9) 100%);
        }
        
        .profile-name {
            font-size: 1.4rem;
            font-weight: bold;
            background: linear-gradient(135deg, #2c3e50 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }
        
        .profile-age {
            color: #d63384;
            font-weight: 600;
            margin-bottom: 8px;
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
        
        .match-criteria {
            background: rgba(248,249,250,0.8);
            border-radius: 18px;
            padding: 20px;
            margin: 20px 0;
            border: 1px solid rgba(233,236,239,0.8);
            backdrop-filter: blur(10px);
        }
        
        .criteria-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 0.9rem;
        }
        
        .criteria-item:last-child {
            margin-bottom: 0;
        }
        
        .criteria-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .criteria-value {
            font-weight: bold;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            min-width: 50px;
            text-align: center;
        }
        
        .criteria-value.high { 
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724; 
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }
        
        .criteria-value.medium { 
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404; 
            box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3);
        }
        
        .criteria-value.low { 
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24; 
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }
        
        .profile-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn-action {
            padding: 14px 20px;
            border: none;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            max-width: 120px;
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
            background: linear-gradient(135deg, rgba(248,249,250,0.9) 0%, rgba(233,236,239,0.7) 100%);
            border-radius: 24px;
            border: 2px dashed rgba(108, 117, 125, 0.3);
            backdrop-filter: blur(10px);
        }
        
        .empty-state i {
            font-size: 5rem;
            background: linear-gradient(135deg, #667eea 0%, #d63384 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
        }
        
        .filter-section {
            background: linear-gradient(135deg, rgba(248,249,250,0.95) 0%, rgba(233,236,239,0.8) 100%);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 35px;
            border: 1px solid rgba(255,255,255,0.3);
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
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
            padding: 14px 16px;
            border: 2px solid rgba(233, 236, 239, 0.8);
            border-radius: 14px;
            background: rgba(255,255,255,0.9);
            transition: all 0.3s ease;
            font-size: 0.95rem;
            backdrop-filter: blur(5px);
        }
        
        .filter-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.3rem rgba(102, 126, 234, 0.15);
            background: rgba(255,255,255,0.95);
        }
        
        .section-header {
            background: linear-gradient(135deg, rgba(248,249,250,0.95) 0%, rgba(233,236,239,0.8) 100%);
            padding: 25px 30px;
            border-radius: 20px;
            border: 1px solid rgba(233, 236, 239, 0.8);
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }
        
        .logout-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            border-radius: 16px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
            position: relative;
            overflow: hidden;
            margin-top: 20px;
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
        
        @keyframes pulse-online {
            0% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(81, 207, 102, 0); }
            100% { box-shadow: 0 0 0 0 rgba(81, 207, 102, 0); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
        
        /* Responsive Design */
        @media (max-width: 1200px) {
            .main-layout {
                grid-template-columns: 320px 1fr;
                gap: 25px;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 25px;
            }
        }
        
        @media (max-width: 992px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            
            .left-sidebar {
                position: relative;
                top: 0;
            }
            
            .profile-grid {
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-row {
                grid-template-columns: 1fr;
            }
            
            .right-content {
                padding: 25px;
            }
            
            .welcome-banner {
                padding: 40px 0 30px;
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
            
            .main-layout {
                padding: 0 15px;
            }
            
            .right-content {
                padding: 20px;
            }
        }
    </style>


     <div class="container mt-4">
        <h1><asp:Literal ID="litPageTitle" runat="server" Text="Welcome to JivanBandhan"></asp:Literal></h1>
        <p><asp:Literal ID="litPageDescription" runat="server" Text="Find your perfect life partner..."></asp:Literal></p>
        
        <!-- Dynamic content साठी Literal controls वापरा -->
    </div>

    <div class="matches-container">
        <!-- Welcome Banner -->
        <div class="welcome-banner">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1 class="marathi-font" style="font-size: 2.5rem; margin-bottom: 10px;">💖 Your Perfect Matches</h1>
                        <p class="marathi-font mb-0" style="font-size: 1.2rem; opacity: 0.8;">Discover profiles that match your preferences and share mutual compatibility</p>
                    </div>
                    <div class="col-md-4 text-right">
                        <div class="d-flex justify-content-end gap-3 flex-wrap">
                            <span class="badge glass-card marathi-font p-3" style="background: rgba(255,255,255,0.9);">
                                💝 <asp:Label ID="lblTotalMatches" runat="server" Text="0" style="font-size: 1.1rem;"></asp:Label> Matches
                            </span>
                            <span class="badge glass-card marathi-font p-3" style="background: rgba(255,255,255,0.9);">
                                ⭐ <asp:Label ID="lblMembershipStatus" runat="server" Text="Free" style="font-size: 1.1rem;"></asp:Label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Layout -->
        <div class="container">
            <div class="main-layout">
                <!-- Left Sidebar - Current User Profile -->
                <div class="left-sidebar glass-card">
                    <div class="user-profile-card">
                        <!-- Large Profile Photo -->
                        <asp:Image ID="imgUserPhoto" runat="server" CssClass="user-photo-large" 
                            ImageUrl="~/Images/default-profile.jpg" 
                            onerror="this.src='Images/default-profile.jpg'" />
                        <div class="user-name marathi-font">
                            <asp:Label ID="lblUserFullName" runat="server" Text=""></asp:Label>
                        </div>
                        <div class="user-details marathi-font" style="background: rgba(248,249,250,0.7); padding: 15px; border-radius: 15px; margin: 10px 0;">
                            <asp:Label ID="lblUserAgeOccupation" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="lblUserLocation" runat="server" Text=""></asp:Label>
                        </div>
                        
                        <!-- Match Statistics -->
                        <div class="quick-stats">
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblMutualMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Mutual</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblTodayMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Today</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblNewMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">New</span>
                            </div>
                            <div class="stat-box">
                                <span class="stat-number"><asp:Label ID="lblPremiumMatches" runat="server" Text="0"></asp:Label></span>
                                <span class="stat-label marathi-font">Premium</span>
                            </div>
                        </div>

                        <!-- Match Criteria Info -->
                        <div class="match-criteria">
                            <h6 class="marathi-font text-primary mb-3" style="text-align: center;">🎯 Your Preferences</h6>
                            <div class="feature-list small">
                                <div class="criteria-item">
                                    <span class="criteria-label">Gender:</span>
                                    <span class="criteria-value high"><asp:Label ID="lblPreferredGender" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Age Range:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredAge" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Education:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredEducation" runat="server" Text=""></asp:Label></span>
                                </div>
                                <div class="criteria-item">
                                    <span class="criteria-label">Occupation:</span>
                                    <span class="criteria-value medium"><asp:Label ID="lblPreferredOccupation" runat="server" Text=""></asp:Label></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Navigation Menu -->
                    <div class="nav-menu">
                        <a class="nav-item" href="Dashboard.aspx">
                            <i class="fas fa-home"></i>
                            <span class="marathi-font">Dashboard</span>
                        </a>
                        <a class="nav-item" href="MyProfile.aspx">
                            <i class="fas fa-user-edit"></i>
                            <span class="marathi-font">My Profile</span>
                        </a>
                        <a class="nav-item active" href="Matches.aspx">
                            <i class="fas fa-heart"></i>
                            <span class="marathi-font">Matched Profiles</span>
                            <asp:Panel ID="pnlMatchesBadge" runat="server" CssClass="nav-badge pulse" Visible="false">
                                <span class="badge-count"><asp:Label ID="lblMatchesCount" runat="server" Text="0"></asp:Label></span>
                            </asp:Panel>
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
                    </div>

                    <!-- Logout Button -->
                    <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" 
                        CssClass="logout-btn marathi-font" OnClick="btnLogout_Click" />
                </div>
                
                <!-- Right Content - Matched Profiles -->
                <div class="right-content glass-card">
                    <!-- Match Filters -->
                    <div class="filter-section">
                        <h5 class="marathi-font mb-3" style="color: #8B0000; font-size: 1.3rem;">
                            <i class="fas fa-filter"></i> Refine Your Matches
                        </h5>
                        <div class="filter-row">
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-heart"></i> Match Type</div>
                                <asp:DropDownList ID="ddlMatchType" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlMatchType_SelectedIndexChanged">
                                    <asp:ListItem Value="all">All Matches</asp:ListItem>
                                    <asp:ListItem Value="mutual">Mutual Matches</asp:ListItem>
                                    <asp:ListItem Value="new">New Today</asp:ListItem>
                                    <asp:ListItem Value="premium">Premium Profiles</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-sort"></i> Sort By</div>
                                <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                                    <asp:ListItem Value="newest">Newest First</asp:ListItem>
                                    <asp:ListItem Value="relevance">Best Match</asp:ListItem>
                                    <asp:ListItem Value="premium">Premium First</asp:ListItem>
                                    <asp:ListItem Value="age">Age</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="filter-group">
                                <div class="filter-label marathi-font"><i class="fas fa-chart-line"></i> Match Score</div>
                                <asp:DropDownList ID="ddlMatchScore" runat="server" CssClass="filter-control" AutoPostBack="true" OnSelectedIndexChanged="ddlMatchScore_SelectedIndexChanged">
                                    <asp:ListItem Value="0">All Scores</asp:ListItem>
                                    <asp:ListItem Value="80">80%+ Match</asp:ListItem>
                                    <asp:ListItem Value="60">60%+ Match</asp:ListItem>
                                    <asp:ListItem Value="40">40%+ Match</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="text-center mt-3">
                            <asp:Button ID="btnFindMore" runat="server" Text="🔍 Find More Matches" 
                                CssClass="btn marathi-font px-4 py-2" 
                                style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 20px; box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);"
                                OnClick="btnFindMore_Click" />
                        </div>
                    </div>

                    <!-- Matched Profiles Section -->
                    <div class="matches-section">
                        <div class="section-header d-flex justify-content-between align-items-center">
                            <h3 class="section-title marathi-font">
                                <i class="fas fa-heart text-danger"></i> 
                                Perfect Matches For You
                                <small class="text-muted marathi-font" style="font-size: 1rem; display: block; margin-top: 8px;">
                                    (<asp:Label ID="lblMatchInfo" runat="server" Text=""></asp:Label>)
                                </small>
                            </h3>
                            <asp:Button ID="btnRefreshMatches" runat="server" Text="🔄 Refresh" 
                                CssClass="btn btn-sm marathi-font" 
                                style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 15px;"
                                OnClick="btnRefreshMatches_Click" />
                        </div>
                        
                        <div class="profile-grid">
                            <asp:Repeater ID="rptMatchedProfiles" runat="server" OnItemDataBound="rptMatchedProfiles_ItemDataBound">
                                <ItemTemplate>
                                    <div class="profile-card" onclick='viewProfile(<%# Eval("UserID") %>)'>
                                        <div class="profile-header-large">
                                            <img src='<%# Eval("Gender").ToString() == "Female" ? "~/Images/female-bg.jpg" : "~/Images/male-bg.jpg" %>' 
                                                 class="profile-bg" alt="background" />
                                            
                                            <!-- Match Score Badge -->
                                            <div class="match-score-badge">
                                                <span class="match-percentage"><%# Eval("MatchPercentage") %>%</span>
                                                <span class="match-label">MATCH</span>
                                            </div>
                                            
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
                                                <asp:Literal ID="ltAge" runat="server" Text='<%# CalculateAgeInline(Eval("DateOfBirth")) %>'></asp:Literal> Years | <%# Eval("Occupation") %>
                                            </div>
                                            <div class="profile-location marathi-font">
                                                <i class="fas fa-map-marker-alt text-muted"></i> 
                                                <%# Eval("City") %>, <%# Eval("State") %>
                                            </div>
                                            
                                            <!-- Match Criteria -->
                                            <div class="match-criteria">
                                                <div class="criteria-item">
                                                    <span class="criteria-label">Age Match:</span>
                                                    <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("AgeMatchScore"))) %>">
                                                        <%# Eval("AgeMatchScore") %>%
                                                    </span>
                                                </div>
                                                <div class="criteria-item">
                                                    <span class="criteria-label">Education:</span>
                                                    <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("EducationMatchScore"))) %>">
                                                        <%# Eval("EducationMatchScore") %>%
                                                    </span>
                                                </div>
                                                <div class="criteria-item">
                                                    <span class="criteria-label">Location:</span>
                                                    <span class="criteria-value <%# GetMatchColor(Convert.ToInt32(Eval("LocationMatchScore"))) %>">
                                                        <%# Eval("LocationMatchScore") %>%
                                                    </span>
                                                </div>
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
                        
                        <asp:Panel ID="pnlNoMatches" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-heart-broken fa-4x text-muted mb-3"></i>
                            <h4 class="marathi-font text-muted">No perfect matches found yet</h4>
                            <p class="marathi-font text-muted">We're working hard to find your perfect match. Please check back later or update your preferences.</p>
                            <div class="mt-4">
                                <asp:Button ID="btnUpdatePreferences" runat="server" Text="⚙️ Update Preferences" 
                                    CssClass="btn marathi-font px-4 py-2 me-3" 
                                    style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 20px;"
                                    OnClick="btnUpdatePreferences_Click" />
                                <asp:Button ID="btnBrowseProfiles" runat="server" Text="👀 Browse All Profiles" 
                                    CssClass="btn marathi-font px-4 py-2" 
                                    style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 20px; color: #495057;"
                                    OnClick="btnBrowseProfiles_Click" />
                            </div>
                        </asp:Panel>

                        <!-- Load More Button -->
                        <div class="text-center mt-4" id="pnlLoadMore" runat="server" visible="false">
                            <asp:Button ID="btnLoadMore" runat="server" Text="📥 Load More Matches" 
                                CssClass="btn marathi-font px-4 py-2" 
                                style="background: rgba(248,249,250,0.8); border: 1px solid rgba(255,255,255,0.3); border-radius: 20px; color: #495057;"
                                OnClick="btnLoadMore_Click" />
                        </div>
                    </div>
                </div>
            </div>
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
            window.location.href = 'ViewUserProfile.aspx?UserID=' + userID;
        }

        // Send Interest Function
        function sendInterest(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

            if (confirm('Are you interested in this profile?')) {
                const button = event.target.closest('.btn-interest') || event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '⏳ Sending...';
                button.disabled = true;

                const currentUserID = document.getElementById('<%= hdnCurrentUserID.ClientID %>').value;

                // AJAX call to send interest
                $.ajax({
                    type: "POST",
                    url: "Matches.aspx/SendInterest",
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
        }

        // Send Message Function
        function sendMessage(event, toUserID) {
            event.stopPropagation();
            event.preventDefault();

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
                    url: "Matches.aspx/SendMessage",
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
                url: "Matches.aspx/ShortlistProfile",
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

        // Add hover effects and animations
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

            // Add parallax effect to background
            window.addEventListener('scroll', function () {
                const scrolled = window.pageYOffset;
                const parallax = document.querySelector('.matches-container::before');
                if (parallax) {
                    parallax.style.transform = `translateY(${scrolled * 0.5}px)`;
                }
            });
        });
    </script>
</asp:Content>--%>