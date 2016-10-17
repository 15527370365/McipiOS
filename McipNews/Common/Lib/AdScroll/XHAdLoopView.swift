//
//  XHAdLoopView.swift
//  XHAdScrollView
//
//  Created by 江欣华 on 16/3/11.
//  Copyright © 2016年 jxh. All rights reserved.
//

import UIKit

class XHAdLoopView: UIView {

    private var pageControl : UIPageControl?
    private var imageScrollView : UIScrollView?
    private var currentPage: NSInteger?
    
    /*******************  重写get方法 **************/
    private var currentImgs = NSMutableArray()
    private var currentImages :NSMutableArray? {
        get{
            currentImgs.removeAllObjects()
            let count = self.images!.count
            var i = NSInteger(self.currentPage!+count-1)%count
            currentImgs.addObject(self.images![i])
            currentImgs.addObject(self.images![self.currentPage!])
            i = NSInteger(self.currentPage!+1)%count
            currentImgs.addObject(self.images![i])
            return currentImgs
        }
    }
    /************************************************/
    
    private var images: NSArray?
    private var autoPlay : Bool?
    private var isFromNet : Bool?
    private var delay : NSTimeInterval?
    
    var delegate:XHAdLoopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame:CGRect ,images:NSArray, autoPlay:Bool, delay:NSTimeInterval, isFromNet:Bool){
        self.init(frame: frame)
        self.images = images;
        self.autoPlay = autoPlay
        self.isFromNet = isFromNet
        self.delay = delay
        self.currentPage = 0
        
        createImageScrollView()
        createPageView()
        
        if images.count<2{
            self.autoPlay = false
            pageControl?.hidden = true
        }
        
        if self.autoPlay == true {
            startAutoPlay()
        }
    }

    //创建图片滚动视图
    private func createImageScrollView(){
        if images?.count == 0 {
            return
        }
        imageScrollView = UIScrollView(frame: self.bounds)
        imageScrollView?.showsHorizontalScrollIndicator = false
        imageScrollView?.showsVerticalScrollIndicator=false
        imageScrollView?.bounces = false
        imageScrollView?.delegate = self
        imageScrollView?.contentSize = CGSizeMake(self.bounds.width*3, 0)
        imageScrollView?.contentOffset = CGPointMake(self.frame.width, 0)
        imageScrollView?.pagingEnabled = true
        self.addSubview(imageScrollView!)
        
        for index in 0..<3 {
            let imageView = UIImageView(frame: CGRectMake(self.bounds.width*CGFloat(index), 0, self.bounds.width, self.bounds.height))
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(XHAdLoopView.imageViewClick)))
            
            
            if self.isFromNet == true {
                
            }
            else{
                imageView.image = UIImage(named: self.currentImages![index] as! String);
            }
            imageScrollView?.addSubview(imageView)
        }
        
    }
    
    //创建pageControl视图
    private func createPageView(){
        if images?.count == 0 {
            return
        }
        let pageW: CGFloat = 80
        let pageH: CGFloat = 25
        let pageX: CGFloat = self.bounds.width - pageW
        let pageY: CGFloat = self.bounds.height - pageH
        pageControl = UIPageControl(frame: CGRectMake(pageX, pageY, pageW, pageH))
        pageControl?.numberOfPages = images!.count
        pageControl?.currentPage = 0
        pageControl?.userInteractionEnabled = false
        self.addSubview(pageControl!)
        
    }
    
    private func startAutoPlay() {
        self.performSelector(#selector(XHAdLoopView.nextPage), withObject: nil, afterDelay: delay!)
    }
    
    func nextPage() {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(XHAdLoopView.nextPage), object: nil)
        imageScrollView!.setContentOffset(CGPointMake(2 * self.frame.width, 0), animated: true)
        self.performSelector(#selector(XHAdLoopView.nextPage), withObject: nil, afterDelay: delay!)
    }
    
    //每次图片滚动时刷新图片
    private func refreshImages(){
        for i in 0..<imageScrollView!.subviews.count {
            let imageView = imageScrollView!.subviews[i] as! UIImageView
            if self.isFromNet == true {
                
            }
            else{
                imageView.image = UIImage(named: self.currentImages![i] as! String);
            }
        }
        
        imageScrollView!.contentOffset = CGPointMake(self.frame.width, 0)
    }
    
    //图片点击
    func imageViewClick(){
        if self.delegate != nil && (self.delegate?.respondsToSelector(#selector(XHAdLoopViewDelegate.adLoopView(_:IconClick:)))) != nil {
            self.delegate!.adLoopView(self, IconClick: currentPage!)
        }
    }

}

extension XHAdLoopView : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPointMake(self.frame.width, 0), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        let width = self.frame.width
        if x >= 2*width {
            currentPage = (currentPage!+1) % self.images!.count
            pageControl!.currentPage = currentPage!
            refreshImages()
        }
        if x <= 0 {
            currentPage = (currentPage!+self.images!.count-1) % self.images!.count
            pageControl!.currentPage = currentPage!
            refreshImages()
        }
    }
}

//自定义代理方法
@objc protocol XHAdLoopViewDelegate:NSObjectProtocol {
    func adLoopView(adLoopView:XHAdLoopView ,IconClick index:NSInteger)
}
