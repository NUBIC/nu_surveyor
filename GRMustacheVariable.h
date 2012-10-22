// The MIT License
//
// Copyright (c) 2012 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "GRMustacheAvailabilityMacros.h"

@class GRMustacheTemplateRepository;

/**
 * A GRMustacheVariable represents a Mustache variable such as `{{name}}`.
 *
 * You will be provided with GRMustacheVariable objects when implementing
 * mustache lambda sections with objects conforming to the
 * deprecated GRMustacheVariableHelper protocol.
 *
 * **Companion guide:** https://github.com/groue/GRMustache/blob/master/Guides/variable_tag_helpers.md
 *
 * @see GRMustacheVariableTagHelper
 *
 * @since v5.1
 * @deprecated v5.3
 */
@interface GRMustacheVariable : NSObject {
@private
    GRMustacheTemplateRepository *_templateRepository;
    id _runtime;
}

/**
 * Renders a template string with the current rendering context.
 *
 * @param string    A template string
 * @param outError  If there is an error loading or parsing template and
 *                  partials, upon return contains an NSError object that
 *                  describes the problem.
 *
 * @return A string containing the rendering of the template string.
 *
 * @since v5.1
 * @deprecated v5.3
 */
- (NSString *)renderTemplateString:(NSString *)string error:(NSError **)outError AVAILABLE_GRMUSTACHE_VERSION_5_1_AND_LATER_BUT_DEPRECATED_IN_GRMUSTACHE_VERSION_5_3;


/**
 * Renders a partial template with the current rendering context.
 *
 * @param name      The name of the partial template.
 * @param outError  If there is an error loading or parsing template and
 *                  partials, upon return contains an NSError object that
 *                  describes the problem.
 *
 * @return A string containing the rendering of the partial template.
 *
 * @since v5.1
 * @deprecated v5.3
 */
- (NSString *)renderTemplateNamed:(NSString *)name error:(NSError **)outError AVAILABLE_GRMUSTACHE_VERSION_5_1_AND_LATER_BUT_DEPRECATED_IN_GRMUSTACHE_VERSION_5_3;

@end
