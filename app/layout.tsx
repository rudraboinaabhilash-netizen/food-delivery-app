import "./globals.css";
import { CartProvider } from "../components/cart-provider";
import Navbar from "../components/navbar";
export const metadata={title:"NANI Eats",description:"Good food. Delivered fast."};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body><CartProvider><Navbar/>{children}</CartProvider></body></html>}